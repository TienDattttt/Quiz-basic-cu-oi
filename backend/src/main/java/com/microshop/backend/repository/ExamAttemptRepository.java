package com.microshop.backend.repository;

import com.microshop.backend.entity.ExamAttempt;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface ExamAttemptRepository extends JpaRepository<ExamAttempt, Integer> {
    boolean existsByAssignment_IdAndStudent_Id(Integer assignmentId, Integer studentId);
    List<ExamAttempt> findByStudent_Id(Integer studentId);
    List<ExamAttempt> findByAssignment_ClassField_Id(Integer classId);
    Optional<ExamAttempt> findByAssignment_IdAndStudent_Id(Integer assignmentId, Integer studentId);
}
