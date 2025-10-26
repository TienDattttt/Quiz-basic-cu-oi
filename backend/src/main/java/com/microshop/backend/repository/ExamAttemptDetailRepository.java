package com.microshop.backend.repository;

import com.microshop.backend.entity.ExamAttemptDetail;
import com.microshop.backend.entity.ExamAttemptDetailId;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface ExamAttemptDetailRepository extends JpaRepository<ExamAttemptDetail, ExamAttemptDetailId> {
    List<ExamAttemptDetail> findByAttempt_Id(Integer attemptId);
}
