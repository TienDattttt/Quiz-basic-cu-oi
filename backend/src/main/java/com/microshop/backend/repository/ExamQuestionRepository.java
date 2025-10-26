package com.microshop.backend.repository;

import com.microshop.backend.entity.ExamQuestion;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface ExamQuestionRepository extends JpaRepository<ExamQuestion, Integer> {
    List<ExamQuestion> findByExam_Id(Integer examId);
}
