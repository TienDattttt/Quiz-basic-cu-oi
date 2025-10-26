package com.microshop.backend.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.Nationalized;

@Getter
@Setter
@Entity
public class Question {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "question_id", nullable = false)
    private Integer id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "subject_id", nullable = false)
    private Subject subject;

    @Nationalized
    @Column(name = "content", nullable = false, length = 500)
    private String content;

    @Nationalized
    @Column(name = "option_a")
    private String optionA;

    @Nationalized
    @Column(name = "option_b")
    private String optionB;

    @Nationalized
    @Column(name = "option_c")
    private String optionC;

    @Nationalized
    @Column(name = "option_d")
    private String optionD;

    @Column(name = "correct_option", nullable = false)
    private Character correctOption;

}