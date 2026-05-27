package com.example.store.mapper;

import com.example.store.dto.OrderDTO;
import com.example.store.entity.Order;
import java.util.List;
import org.mapstruct.Mapper;

@Mapper(componentModel = "spring")
public interface OrderMapper {
    OrderDTO orderToOrderDTO(Order order);

    List<OrderDTO> ordersToOrderDTOs(List<Order> orders);
}
