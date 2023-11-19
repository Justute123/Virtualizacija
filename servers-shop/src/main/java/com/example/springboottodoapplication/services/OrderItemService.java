package com.example.springboottodoapplication.services;

import com.example.springboottodoapplication.models.OrderItem;
import com.example.springboottodoapplication.repositories.OrderItemRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.security.PublicKey;
import java.time.Instant;
import java.util.Optional;

@Service
public class OrderItemService {
    @Autowired
    private OrderItemRepository orderItemRepository;

    public Iterable<OrderItem> getAll(){
        return orderItemRepository.findAll();
    }

    public Optional<OrderItem> getById(Long id){
        return orderItemRepository.findById(id);
    }

    public OrderItem save(OrderItem orderItem){
        if (orderItem.getId() == null){
            orderItem.setCreatedAt(Instant.now());
        }
        return orderItemRepository.save(orderItem);
    }

    public void delete(OrderItem orderItem){
        orderItemRepository.delete(orderItem);
    }
}
