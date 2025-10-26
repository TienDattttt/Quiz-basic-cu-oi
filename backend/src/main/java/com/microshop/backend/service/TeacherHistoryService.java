package com.microshop.backend.service;

import com.microshop.backend.dto.ExamHistoryDetailWrapper;
import com.microshop.backend.dto.ExamHistoryResponse;

import java.util.List;

public interface TeacherHistoryService {
    List<ExamHistoryResponse> getHistoryByClass(Integer classId);
    ExamHistoryDetailWrapper getAttemptDetail(Integer attemptId);
}
