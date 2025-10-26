package com.microshop.backend.service;

import com.microshop.backend.dto.ExamHistoryDetailWrapper;
import com.microshop.backend.dto.ExamHistoryResponse;

import java.util.List;

public interface StudentHistoryService {
    List<ExamHistoryResponse> getHistory(Integer studentId);
    ExamHistoryDetailWrapper getHistoryDetail(Integer attemptId);
}
