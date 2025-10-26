package com.microshop.backend.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Embeddable;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.Hibernate;

import java.io.Serializable;
import java.util.Objects;

@Getter
@Setter
@Embeddable
public class ClassroomStudentId implements Serializable {
    private static final long serialVersionUID = 4516437163583453058L;
    @Column(name = "class_id", nullable = false)
    private Integer classId;

    @Column(name = "student_id", nullable = false)
    private Integer studentId;

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || Hibernate.getClass(this) != Hibernate.getClass(o)) return false;
        ClassroomStudentId entity = (ClassroomStudentId) o;
        return Objects.equals(this.studentId, entity.studentId) &&
                Objects.equals(this.classId, entity.classId);
    }

    @Override
    public int hashCode() {
        return Objects.hash(studentId, classId);
    }

}