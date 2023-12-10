package com.example.springboottodoapplication.services;

import com.example.springboottodoapplication.models.OrderItem;
import com.example.springboottodoapplication.repositories.OrderItemRepository;
import com.example.springboottodoapplication.util.VMCreator;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.env.Environment;
import org.springframework.stereotype.Service;

import java.security.PublicKey;
import java.time.Instant;
import java.util.Optional;

@Service
public class OrderItemService {
    @Autowired
    Environment environment;
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
        VMCreator vmCreator = new VMCreator(orderItem,
                environment.getProperty("opennebula_name"),
                environment.getProperty("opennebula_token"));

        vmCreator.create();
        return orderItemRepository.save(orderItem);
    }

    public void delete(OrderItem orderItem){
        orderItemRepository.delete(orderItem);
    }
}
