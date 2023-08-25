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
    case isReportExist = "이미 신고한 피드 입니다."
    case isReportSuccess = "신고 내용이 접수되었습니다.\n검토까지는 최대 24시간 소요됩니다."
    case isReportFailed = "오류가 발생했습니다.\n다시 시도해주세요."
    case loginOutConfirm = "로그아웃 하시겠습니까?"
    case removeMemberConfirm = "회원을 탈퇴하시겠습니까?\n탈퇴하실 경우 작성한 피드까지 전부 삭제됩니다."
}
