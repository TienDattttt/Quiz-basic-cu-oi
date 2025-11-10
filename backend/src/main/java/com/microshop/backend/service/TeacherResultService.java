package com.microshop.backend.service;

import com.microshop.backend.dto.*;
import java.util.List;

public interface TeacherResultService {
    List<ClassResponse> getTeacherClasses(String username);
    List<ExamResponse> getExamsByClass(Integer classId);
    List<StudentExamResultResponse> getStudentResults(Integer examId);
    ExamHistoryDetailWrapper getAttemptDetail(Integer attemptId);
}
