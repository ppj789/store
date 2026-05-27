package com.example.store.dto;

import java.util.List;
import lombok.Data;

@Data
public class CustomerDTO {
    private Long id;
    private String name;
    private List<CustomerOrderDTO> orders;
}
