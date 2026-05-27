# Plan: Add Customer CRUD and Order Details Endpoints

## Current State

### Existing Endpoints
| Controller | Endpoint | Method | Description |
|------------|----------|--------|-------------|
| [`CustomerController`](src/main/java/com/example/store/controller/CustomerController.java:15) | `GET /customer` | `@GetMapping` | Get all customers |
| [`CustomerController`](src/main/java/com/example/store/controller/CustomerController.java:15) | `POST /customer` | `@PostMapping` | Create a new customer |
| [`OrderController`](src/main/java/com/example/store/controller/OrderController.java:15) | `GET /order` | `@GetMapping` | Get all orders |
| [`OrderController`](src/main/java/com/example/store/controller/OrderController.java:15) | `POST /order` | `@PostMapping` | Create a new order |

### Key Components
- **Entities**: [`Customer`](src/main/java/com/example/store/entity/Customer.java:10), [`Order`](src/main/java/com/example/store/entity/Order.java:9)
- **Repositories**: [`CustomerRepository`](src/main/java/com/example/store/repository/CustomerRepository.java:7), [`OrderRepository`](src/main/java/com/example/store/repository/OrderRepository.java:7)
- **DTOs**: [`CustomerDTO`](src/main/java/com/example/store/dto/CustomerDTO.java:7), [`OrderDTO`](src/main/java/com/example/store/dto/OrderDTO.java:6)
- **Mappers**: [`CustomerMapper`](src/main/java/com/example/store/mapper/CustomerMapper.java:10), [`OrderMapper`](src/main/java/com/example/store/mapper/OrderMapper.java:12)

---

## Proposed Changes

### 1. [`CustomerController`](src/main/java/com/example/store/controller/CustomerController.java:15) - New Endpoints

| Endpoint | Method | Description |
|----------|--------|-------------|
| `GET /customer/{id}` | `@GetMapping("/{id}")` | Get customer by ID, return 404 if not found |
| `PUT /customer/{id}` | `@PutMapping("/{id}")` | Update customer by ID, return 404 if not found |
| `DELETE /customer/{id}` | `@DeleteMapping("/{id}")` | Delete customer by ID, return 404 if not found |

### 2. [`OrderController`](src/main/java/com/example/store/controller/OrderController.java:15) - New Endpoint

| Endpoint | Method | Description |
|----------|--------|-------------|
| `GET /order/{id}` | `@GetMapping("/{id}")` | Get order by ID, return 404 if not found |

---

## Implementation Details

### CustomerController.java

```java
@GetMapping("/{id}")
public CustomerDTO getCustomerById(@PathVariable Long id) {
    Customer customer = customerRepository.findById(id)
        .orElseThrow(() -> new RuntimeException("Customer not found with id: " + id));
    return customerMapper.customerToCustomerDTO(customer);
}

@PutMapping("/{id}")
public CustomerDTO updateCustomer(@PathVariable Long id, @RequestBody Customer customer) {
    Customer existingCustomer = customerRepository.findById(id)
        .orElseThrow(() -> new RuntimeException("Customer not found with id: " + id));
    existingCustomer.setName(customer.getName());
    return customerMapper.customerToCustomerDTO(customerRepository.save(existingCustomer));
}

@DeleteMapping("/{id}")
@ResponseStatus(HttpStatus.NO_CONTENT)
public void deleteCustomer(@PathVariable Long id) {
    Customer customer = customerRepository.findById(id)
        .orElseThrow(() -> new RuntimeException("Customer not found with id: " + id));
    customerRepository.delete(customer);
}
```

### OrderController.java

```java
@GetMapping("/{id}")
public OrderDTO getOrderById(@PathVariable Long id) {
    Order order = orderRepository.findById(id)
        .orElseThrow(() -> new RuntimeException("Order not found with id: " + id));
    return orderMapper.orderToOrderDTO(order);
}
```

---

## Design Decisions

1. **Error Handling**: Use `Optional.get()` with `orElseThrow` to return 404 for non-existent resources
2. **PUT Behavior**: Verify existence first, then update fields individually
3. **DELETE Behavior**: Verify existence first, then delete
4. **No new DTOs needed**: Existing DTOs are sufficient for all endpoints
5. **No new mappers needed**: Existing mappers handle all conversions

---

## Files to Modify

1. [`src/main/java/com/example/store/controller/CustomerController.java`](src/main/java/com/example/store/controller/CustomerController.java)
2. [`src/main/java/com/example/store/controller/OrderController.java`](src/main/java/com/example/store/controller/OrderController.java)
