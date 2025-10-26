package com.microshop.backend.service;

import com.microshop.backend.dto.StudentExamResponse;
import java.util.List;

public interface StudentExamService {
    List<StudentExamResponse> getExamsByStudent(Integer studentId);
}
