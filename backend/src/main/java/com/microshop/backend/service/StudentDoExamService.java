package com.microshop.backend.service;

import com.microshop.backend.dto.ExamDetailResponse;
import com.microshop.backend.dto.ExamResultResponse;
import com.microshop.backend.dto.ExamSubmitRequest;

public interface StudentDoExamService {
    ExamResultResponse submit(Integer examId, ExamSubmitRequest request);
    ExamDetailResponse getExamDetail(Integer examId, Integer studentId);
}
