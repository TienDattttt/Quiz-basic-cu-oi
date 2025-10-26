package com.microshop.backend.service.impl;

import com.microshop.backend.dto.ExamAssignmentRequest;
import com.microshop.backend.dto.ExamAssignmentResponse;
import com.microshop.backend.entity.Classroom;
import com.microshop.backend.entity.Exam;
import com.microshop.backend.entity.ExamAssignment;
import com.microshop.backend.repository.ClassroomRepository;
import com.microshop.backend.repository.ExamAssignmentRepository;
import com.microshop.backend.repository.ExamRepository;
import com.microshop.backend.service.ExamAssignmentService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class ExamAssignmentServiceImpl implements ExamAssignmentService {

    private final ExamAssignmentRepository repo;
    private final ExamRepository examRepo;
    private final ClassroomRepository classroomRepo;

    @Override
    public ExamAssignmentResponse assign(ExamAssignmentRequest request) {
        Exam exam = examRepo.findById(request.getExamId())
                .orElseThrow(() -> new RuntimeException("Exam not found"));
        Classroom classroom = classroomRepo.findById(request.getClassId())
                .orElseThrow(() -> new RuntimeException("Class not found"));

        ExamAssignment assignment = new ExamAssignment();
        assignment.setExam(exam);
        assignment.setClassField(classroom);
        assignment = repo.save(assignment);

        ExamAssignmentResponse res = new ExamAssignmentResponse();
        res.setId(assignment.getId());
        res.setExamId(exam.getId());
        res.setClassId(classroom.getId());
        res.setExamTitle(exam.getTitle());
        return res;
    }

    @Override
    public List<ExamAssignmentResponse> getByClass(Integer classId) {
        return repo.findByClassField_Id(classId).stream().map(a -> {
            ExamAssignmentResponse res = new ExamAssignmentResponse();
            res.setId(a.getId());
            res.setExamId(a.getExam().getId());
            res.setClassId(a.getClassField().getId());
            res.setExamTitle(a.getExam().getTitle());
            return res;
        }).toList();
    }
}
