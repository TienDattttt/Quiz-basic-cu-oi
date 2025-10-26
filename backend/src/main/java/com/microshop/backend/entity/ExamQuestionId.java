package com.microshop.backend.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Embeddable;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.hibernate.Hibernate;

import java.io.Serializable;
import java.util.Objects;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Embeddable
public class ExamQuestionId implements Serializable {
    private static final long serialVersionUID = 7543854336109886579L;
    @Column(name = "exam_id", nullable = false)
    private Integer examId;

    @Column(name = "question_id", nullable = false)
    private Integer questionId;

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || Hibernate.getClass(this) != Hibernate.getClass(o)) return false;
        ExamQuestionId entity = (ExamQuestionId) o;
        return Objects.equals(this.questionId, entity.questionId) &&
                Objects.equals(this.examId, entity.examId);
    }

    @Override
    public int hashCode() {
        return Objects.hash(questionId, examId);
    }

}