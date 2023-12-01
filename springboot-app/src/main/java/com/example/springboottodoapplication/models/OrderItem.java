package com.example.springboottodoapplication.models;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;
import java.time.Instant;

@Getter
@Setter
@Entity
@Table(name = "orders")
public class OrderItem implements Serializable {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;
    private String os;
    private double cpu;
    private int ram;
    private int days;
    private Instant createdAt;

    @Override
    public String toString() {
        return "Order{" +
                "id=" + id +
                ", os='" + os + '\'' +
                ", cpu=" + cpu +
                ", ram=" + ram +
                ", days=" + days +
                '}';
    }
}
