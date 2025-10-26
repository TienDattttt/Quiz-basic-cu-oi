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



@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@Embeddable
public class ExamAttemptDetailId implements Serializable {
    private static final long serialVersionUID = -831866687924911792L;
    @Column(name = "attempt_id", nullable = false)
    private Integer attemptId;

    @Column(name = "question_id", nullable = false)
    private Integer questionId;

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || Hibernate.getClass(this) != Hibernate.getClass(o)) return false;
        ExamAttemptDetailId entity = (ExamAttemptDetailId) o;
        return Objects.equals(this.questionId, entity.questionId) &&
                Objects.equals(this.attemptId, entity.attemptId);
    }

    @Override
    public int hashCode() {
        return Objects.hash(questionId, attemptId);
    }

}