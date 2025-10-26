package com.microshop.backend.repository;

import com.microshop.backend.entity.Exam;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface ExamRepository extends JpaRepository<Exam, Integer> {
    List<Exam> findBySubject_Id(Integer subjectId);
}
