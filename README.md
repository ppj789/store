# Store Application
The Store application keeps track of customers and orders in a database.

# Assumptions
This README assumes you're using a posix environment. It's possible to run this on Windows as well:
* Instead of `./gradlew` use `gradlew.bat`
* The syntax for creating the Docker container is different. You could also install PostgreSQL on bare metal if you prefer


# Prerequisites
This service assumes the presence of a postgresql 16.2 database server running on localhost:5433 (note the non-standard port)
It assumes a username and password `admin:admin` can be used.
It assumes there's already a database called `store`

You can start the PostgreSQL instance like this:
```shell
docker run -d \
  --name postgres \
  --restart always \
  -e POSTGRES_USER=admin \
  -e POSTGRES_PASSWORD=admin \
  -e POSTGRES_DB=store \
  -v postgres:/var/lib/postgresql/data \
  -p 5433:5432 \
  postgres:16.2 \
  postgres -c wal_level=logical
```

# Running the application
You should be able to run the service using
```shell
./gradlew bootRun
```

The application uses Liquibase to migrate the schema. Some sample data is provided. You can create more data by reading the documentation in utils/README.md

# Data model
An order has an ID, a description, and is associated with the customer which made the order.
A customer has an ID, a name, and 0 or more orders.

# API
Two endpoints are provided:
   * /order
   * /customer

Each of them supports a POST and a GET. The data model is circular - a customer owns a number of orders, and that order necessarily refers back to the customer which owns it.
To avoid loops in the serializer, when writing out a Customer or an Order, they're mapped to CustomerDTO and OrderDTO which contain truncated versions of the dependent object - CustomerOrderDTO and OrderCustomerDTO respectively.

The API is documented in the OpenAPI file OpenAPI.yaml. Note that this spec includes part of one of the tasks below (the new /products endpoint)

# Tasks

1. Extend the order endpoint to find a specific order, by ID
2. Extend the customer endpoint to find customers based on a query string to match a substring of one of the words in their name
3. Users have complained that in production the GET endpoints can get very slow. The database is unfortunately not co-located with the application server, and there's high latency between the two. Identify if there are any optimisations that can improve performance
4. Add a new endpoint /products to model products which appear in an order:
      * A single order contains 1 or more products. 
      * A product has an ID and a description. 
      * Add a POST endpoint to create a product
      * Add a GET endpoint to return all products, and a specific product by ID
        * In both cases, also return a list of the order IDs which contain those products
      * Change the orders endpoint to return a list of products contained in the order

# Bonus points
1. Implement a CI pipeline on the platform of your choice to build the project and deliver it as a Dockerized image

# Notes on the tasks
Assume that the project represents a production application.
Think carefully about the impact on performance when implementing your changes
The specifications of the tasks have been left deliberately vague. You will be required to exercise judgement about what to deliver - in a real world environment, you would clarify these points in refinement, but since this is a project to be completed without interaction, feel free to make assumptions - but be prepared to defend them when asked.
There's no CI pipeline associated with this project, but in reality there would be. Consider the things that you would expect that pipeline to verify before allowing your code to be promoted
Feel free to refactor the codebase if necessary. Bad choices were deliberately made when creating this project.



## Jason's Corner
I want to be upfront about my AI usage during this technical project.

I do not typically rely heavily on AI in my day-to-day development work, so I outside of my job I try to maintain at least compentency in it. That said, I saw this assignment as a good opportunity to learn more about modern AI-assisted workflows and apply them in a practical environment. 

During the initial interview, I asked permission regarding AI usage, and I wanted to clearly acknowledge where it has been used in this project.
I also tried to keep the tooling and models local where possible, so that everything used during development remained on my own machine rather than relying on external hosted services.

For this assignment, I experimented with running Ollama locally together with Roo Code using Qwen 3.6. One of the reasons I chose Roo Code was to explore the BMAD workflow, which was something new to me and part of the learning experience I wanted to gain from this project.

My goal with using these tools was not to replace understanding or ownership of the work, but rather to explore how AI can assist with development workflows while still ensuring I understand and can explain the implementation decisions being made.

Hopefully this assignment provides value on both sides. For me, it has been a chance to learn more about AI-assisted development, and for you, perhaps there is something useful or interesting to take away from the approach as well.


## References
BMAD Method
https://github.com/bmad-code-org/bmad-method

Ollama
https://ollama.com/

Roo Code
https://github.com/RooCodeInc/Roo-Code


## Running the project (Docker)

Start all services:

```bash
docker compose up -d

To rebuild from scratch:

docker compose up -d --build

Once running, access:

Swagger UI:
http://localhost:8080/swagger-ui/index.html
OpenAPI spec:
http://localhost:8080/v3/api-docs




