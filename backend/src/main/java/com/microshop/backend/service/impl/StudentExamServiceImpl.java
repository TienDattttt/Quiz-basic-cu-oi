package com.microshop.backend.service.impl;

import com.microshop.backend.dto.StudentExamResponse;
import com.microshop.backend.entity.ClassroomStudent;
import com.microshop.backend.entity.ExamAssignment;
import com.microshop.backend.repository.ClassroomStudentRepository;
import com.microshop.backend.repository.ExamAssignmentRepository;
import com.microshop.backend.service.StudentExamService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.*;

@Service
@RequiredArgsConstructor
public class StudentExamServiceImpl implements StudentExamService {

    private final ClassroomStudentRepository classroomStudentRepo;
    private final ExamAssignmentRepository examAssignmentRepo;

    @Override
    public List<StudentExamResponse> getExamsByStudent(Integer studentId) {

        // 1. tìm lớp mà student thuộc
        List<ClassroomStudent> list = classroomStudentRepo.findByStudent_Id(studentId);
        if (list.isEmpty()) {
            return Collections.emptyList();
        }

        // tạm thời 1 student chỉ ở 1 class (đúng theo use case quiz)
        Integer classId = list.get(0).getClassField().getId();

        // 2. lấy exam assignment theo class
        List<ExamAssignment> assignments = examAssignmentRepo.findByClassField_Id(classId);

        // 3. mapping sang DTO trả về
        return assignments.stream().map(a -> {
            StudentExamResponse res = new StudentExamResponse();
            res.setExamId(a.getExam().getId());
            res.setTitle(a.getExam().getTitle());
            res.setDurationMinutes(a.getExam().getDurationMinutes());
            return res;
        }).toList();
    }
}
