//
//  MapView.swift
//  FeedMap
//
//  Created by 신이삭 on 2023/08/22.
//

import SwiftUI
import GoogleMaps
import SnapKit
import Kingfisher

struct MapView: UIViewRepresentable {
    @Binding var markersData: [FeedRawData]?
    @Binding var zoomLevel: Float
    @Binding var moveLocation: CLLocation?
    @ObservedObject var mapVM: MapVM
        
    let gMap = GMSMapView(frame: .zero)

    func makeUIView(context: Context) -> GMSMapView {

        gMap.camera = GMSCameraPosition.camera(
            withLatitude: moveLocation?.coordinate.latitude ?? LocationManager.shared.currentLocation.coordinate.latitude,
            longitude: moveLocation?.coordinate.longitude ?? LocationManager.shared.currentLocation.coordinate.longitude,
            zoom: zoomLevel)
        gMap.delegate = context.coordinator
        gMap.isUserInteractionEnabled = true
        gMap.isMyLocationEnabled = true
        gMap.mapType = .normal
        gMap.setMinZoom(5.0, maxZoom: 20.0)
        gMap.settings.myLocationButton = true
        
        return gMap
    }
    
    func updateUIView(_ uiView: GMSMapView, context: Context) {
        uiView.clear()
        
        if let datas = self.markersData {
            if datas.count > 0 {
                datas.forEach { data in
                    guard let lat = data.latitude,
                          let lng = data.longitude,
                          let dLat = Double(lat),
                          let dLng = Double(lng) else { return }
                    
                    let loca = CLLocation(latitude: dLat, longitude: dLng)
                    self.createMarker(mapView: uiView, loca: loca, data: data)
                }
            }
        }
        
        if let location = self.moveLocation {
            self.mapCameraMove(mapView: uiView, location: location)
        }

    }
    
    func makeCoordinator() -> MapViewCoordinator {
        return MapViewCoordinator(
            mapView: self,
            zoomLevel: self.zoomLevel,
            moveLocation: self.moveLocation,
            vm: self.mapVM
        )
    }
    
    
    final class MapViewCoordinator: NSObject, GMSMapViewDelegate {
        var mapView: MapView
        var cLocation: CLLocation?
        var zoomLevel: Float = 15
        var moveLocation: CLLocation?
        var vm: MapVM
        
        init(mapView: MapView, cLocation: CLLocation? = nil, zoomLevel: Float, moveLocation: CLLocation? = nil, vm: MapVM) {
            self.mapView = mapView
            self.cLocation = cLocation
            self.zoomLevel = zoomLevel
            self.moveLocation = moveLocation
            self.vm = vm
        }

        
        // 마커클릭
        func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
            if let data = marker.userData as? FeedRawData {
                self.vm.selectFeedRawData.send(data)
                self.vm.isSelectTab = true

//                if let img = data.img1,
//                   let url = URL(string: img) {
//                    self.selectTabImgV.kf.setImage(with: url)
//                }
//                self.selectTabCmtLB.text = data.comment
//                self.selectTabAddrLB.text = data.addr
//                self.selectTabTitleLB.text = data.title
//                self.selectTabDateLB.text = data.date?.wddSimpleDateForm()
//                self.selectTabV.isHidden = false
            }
            return true
        }
        
        func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
            let zoomLevel = mapView.camera.zoom
            self.zoomLevel = zoomLevel
        }
        
        // 지도클릭
        func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
            self.vm.isSelectTab = false
            //      let marker = GMSMarker(position: coordinate)
            //      self.mapView.polygonPath.append(marker)
        }
        
        // 지도 중앙 위치
        func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
            let clocation: CLLocation = CLLocation(
                latitude: position.target.latitude,
                longitude: position.target.longitude
            )
            
            self.vm.centerLocation = clocation
        }
        
    }
}

extension MapView {
    private func mapCameraMove(mapView: GMSMapView, location: CLLocation) {
        let camera = GMSCameraPosition.camera(
            withLatitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude,
            zoom: mapView.camera.zoom
        )
        mapView.camera = camera
        self.moveLocation = nil
    }
    
    private func createMarker(mapView: GMSMapView, loca: CLLocation, data: FeedRawData) {
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: loca.coordinate.latitude, longitude: loca.coordinate.longitude)
        marker.title = data.addr
        marker.snippet = data.title
        
        marker.userData = data
        if let img = data.img1,
           let url = URL(string: img) {
            let v = UIView()
            v.frame = .init(x: 0, y: 0, width: 45, height: 45)
            v.layer.cornerRadius = v.frame.width / 2
            v.layer.borderColor = UIColor.red.cgColor
            v.layer.borderWidth = 2
            v.clipsToBounds = true
            let imgV = UIImageView()
            v.addSubview(imgV)
            imgV.snp.makeConstraints {
                $0.leading.trailing.top.bottom.equalToSuperview()
            }
            imgV.kf.setImage(with: url) { result in
                switch result {
                case .success(let value):
                    print("Task done for: \(value.source.url?.absoluteString ?? "")")
                    marker.iconView = v
                
                case .failure(let error):
                    print("Job failed: \(error.localizedDescription)")
                }
            }
        }
        marker.map = mapView
    }
}
