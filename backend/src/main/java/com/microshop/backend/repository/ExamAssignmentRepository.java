package com.microshop.backend.repository;

import com.microshop.backend.entity.ExamAssignment;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface ExamAssignmentRepository extends JpaRepository<ExamAssignment, Integer> {
    List<ExamAssignment> findByClassField_Id(Integer classId);
    Optional<ExamAssignment> findFirstByExam_IdAndClassField_Id(Integer examId, Integer classId);
    Optional<ExamAssignment> findFirstByExam_Id(Integer examId);

}
