//
//  AlertType.swift
//  FeedMap
//
//  Created by 신이삭 on 2023/08/21.
//

import Foundation

enum AlertType: String, CaseIterable {
    case joinSuccess = "가입되었습니다."
    case feedWriteSuccess = "등록되었습니다."
    case isJoinedAlert = "이미 가입한 사용자 입니다."
    case isJoinFailed = "문제가 발생하였습니다.\n다시 시도해주세요."
    case isCheckCurrentLocationFail = "현재 위치를 찾을 수 없습니다.\n앱 설정으로 가서 위치서비스를 허용하시겠어요?"
    case feedExists = "이 장소에 이미 등록한 피드가 있습니다."
    case feedNotExists = "이 장소에 등록된 피드가 없습니다.\n피드를 등록해주세요"
    case feedTitleNotExists = "제목을 입력해주세요."
    case feedCommentNotExists = "내용을 입력해주세요."
    case feedImgNotExists = "대표 이미지를 등록해주세요."
    case feedDeleteSuccess = "삭제되었습니다."
    case feedDeleteConfirm = "삭제 하시겠습니까?"
}
