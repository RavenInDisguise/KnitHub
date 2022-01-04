# English - Inglés
# KnitHub 🧶
Development of a relational database using MYSQL, as well as its NodeJS and Java APIs, in addition, a demo using Kotlin for the Databases I course at Tecnológico de Costa Rica. I Semester, 2021.

# Choosen system
[Pre-proyecto BDI.pdf](https://github.com/RavenInDisguise/KnitHub/files/7805282/Pre-proyecto.BDI.pdf)

## Agreed implementations

### Functions to implement, Consumer, Backoffice, others:
* Users based on the access device.
* Optional a nickname and optional link to a social network.
* As a consumer I can record my patterns which are step by step descriptions of movements, types of needles, fabrics, colors, yarns.
* Also the user can start new projects to keep track of time, materials, patterns and others used in the project.
* A pattern can be published to the Marketplace.
* There must be a level of restriction in the free tier regarding patterns and projects.
* In the patterns you could attach photos and videos to serve as a guide.
* Some way to categorize the patterns based on your application and also search by names.
* People upload the patterns to the store, with the price they want, and the platform earns a fee for the transaction.
* There must be one-time payments, similar to buying a mobile app, the fees should be configurable.
* Events log.
* First Central American version, do it via payment gateway. Functions that will not be implemented.
* Exchange of ideas, friends and social.
* Comments, reviews.
* Qualification of employers or people.
* Backoffice functions.
* There is no multi-currency or multi-language.

### Where there are transactions:
* Employer payments.
* Subscription plans above the free tier.
* Save a project.

### Sensitive information: 
* Monetary payments.

## Project instructions 
The system, or the application that is mentioned in the statement of this project corresponds to the system that your working group negotiated with the professor. At the end of this statement you can find its corresponding file where it is detailed which things should be included in the project, which ones are left out, and also two categories that will be mentioned in the statement are classified: transactions and sensitive information, which are defined in the token.

### Realize relational databases:

1. Based on the defined system, proceed to perform the following tasks:
2. Design and implementation of the database in MySQL, the design must be done in workbench or some other ER modeling tool that generates code for MySQL
3. The database engine must be run as a Docker container.
4. The scripts, source code and any other file must be delivered as a github repository, there must be a main branch where the project will be reviewed, another develop branch where the merge and tests will be done before moving to the official version in main, finally at least one branch per group member. The commits of all the members will be reviewed throughout the duration of the project, with last minute commits being negative for students. It is recommended to use the gitflow methodology.
5. The initial database creation script will be done only once, for this, you must do the design and will have the right to two checks with the teacher, once you have the stable version proceed to generate the creation script and upload it to github, then all the other changes to the DB, stored procedures, scripts and others, you must bring them with version control using flyway.
6. The following tasks can be performed in a single script in multiple script files, the latter is recommended.
7. Script to fill the database for the catalog information that is necessary for the operation of the database.
8. Create at least two views that are useful for the system, remember that views are useful when you need to see certain information together from several tables that the relational model keeps separate.
9. Create at least 4 stored procedures that perform read operations that make sense and are useful for the system and that these stored procedures make use of the views.
10. Write two transactional stored procedures, useful for the system that writes in at least 3 tables
11. Make a select that creates a dynamic column in a query whose dynamic column seeks to generate possible data groups, the CASE statement is recommended.
12. Create a transactional stored procedure that calls within the transaction another transactional SP and this one another SP that is also transactional. (Two-tier). Each stored procedure must affect at least two tables. Demonstrate the operation of commit and rollback in this SP, to test it, it is only invoked with correct values and with incorrect values.
13. Create a stored procedure that returns the result of a query of at least 3 joined tables in json format.
Create a stored procedure that inserts N records in a table, taking the correctly identified data from a temporary table free of restrictions that was previously filled.
14. No stored procedure should receive IDs by parameter, they always receive names and with these the IDs within the SPs are found.
15. Create a query (s) for each of the following types of statements and / or operators in such a way that their use is clearly demonstrated:
to. Use of a cursor.
b. Use of a trigger.
c. A substring.
16. A query that returns a list of the amounts and people, categorized by year and month of those monies that could not be collected, in the query it should be possible to see the categories, names and amounts duly grouped
17. A query that returns the volume of operations of use of the system per month in a range of dates, classified between low volume, medium volume and high volume
18. Read API, proceed to implement in nodejs an api using REST over HTTP, which must have a minimum of routers, handlers and the implementation, for this create a single generic class that is capable of calling any SP in the database , the implementations make use of this class to make the specific calls to the SPs, include in the API at least the necessary methods to access the 4 stored reading procedures, you can add more if necessary. The server for this backend must be running as a Docker container. The use of an existing boilerplate is recommended.
19. Write API, proceed to implement an API in Java, using REST over HTTP, in this case use it to access the transactional SP that you implemented previously, in the same way, create a generic class that can access the DB and call to any SP, the implementation classes are the ones who know the specific calls.
20. Implement a small demo in kotlin if it is a mobile or web app, using pure javascript, or reactJS, the above depends on the application your group selected. This demo is for your application and you should only call those methods that the APIs offer, remember that it is a demo, the priority of this course falls on the database and its implementation, the apis and the demo are only to demonstrate access and use of the database. Choose carefully which SP to implement in a way that makes sense for the demo and apis. 

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


# Spanish - Español 
# KnitHub 🧶
Desarrollo de una base de datos relacional usando MYSQL, así como sus APIs de NodeJS y Java, además, una demo haciendo uso de Kotlin para el curso Bases de Datos I del Tecnológico de Costa Rica. I Semestre, 2021.

# Sistema elegido
[Pre-proyecto BDI.pdf](https://github.com/RavenInDisguise/KnitHub/files/7805282/Pre-proyecto.BDI.pdf)

## Implementaciones acordadas

### Funciones a implementar, Consumer, Backoffice, otros:
* Usuarios basados en el dispositivo de acceso.
* Opcional un nickname y opcional ligarlo a una red social.
* Como consumidor puedo grabar mis patrones que son descripciones paso a paso de los movimientos, tipos de agujas, telas, colores, lanas.
* También el usuario puede iniciar proyectos nuevos para llevar registro de tiempo, materiales, patrones y demás utilizado en el proyecto.
* Un patrón puede ser publicado al Marketplace.
* Tiene que existir un nivel de restricción en el free tier referente a patrones y proyectos.
* En los patrones podria adjuntar fotos y videos para que sirvan de guía.
* Alguna forma de categorizar los patrones según su aplicación y también buscar por nombres.
* Las personas suben los patrones al store, con el precio que ellos deseen, y la plataforma gana un fee por la transacción.
* Tiene que haber pagos one time, similar a comprar un app mobile, los fee deberían configurables.
* Bitácora de eventos.
* Primer versión centro américa, hacerlo via pasarela de pagos Funciones que no se implementaran.
* Intercambio de ideas, amigos y social.
* Comentarios, reviews.
* Calificación de patrones o de personas.
* Funciones de backoffice.
* No hay multimoneda ni multi idioma.

### Donde hay transacciones:
* Pagos de los patrones.
* Planes de suscripción por encima del free tier.
* Grabar un proyecto.
 
### Información sensible:
* Pagos monetarios.

## Instrucciones del proyecto

El sistema, o la aplicación que se menciona en el enunciado de este proyecto corresponde al sistema que su grupo de trabajo negoció con el profesor. Al final de este enunciado podrá encontrar su ficha correspondiente donde se detalla que cosas deben ser incluidas en el proyecto, cuáles quedan por fuera, y además se clasifican dos categorías que se mencionarán en el enunciado: transacciones y información sensible, las cuales están definidas en la ficha.


### Realize relational databases:
Basado en el sistema definido proceda a realizar las siguientes tareas:
1. Diseño e implementación de la base de datos en MySQL, el diseño debe hacerse en workbench o alguna otra herramienta de modelado ER que genere código para MySQL
2. El motor de base de datos deberá ser ejecutado como un container de Docker.
3. Los scripts, código fuente y cualquier otro archivo deberán entregarlo como un repositorio de github, debe existir un branch de main en el cuál se hará la revisión del proyecto, otro branch de develop donde se harán los merge y pruebas antes de pasar a versión oficial en main, finalmente al menos un branch por integrante de grupo. Se revisarán los commits de todos los integrantes a lo largo de la duración del proyecto, siendo negativo para los estudiantes commits de último momento. Se recomienda utilizar la metodología de gitflow.
4. El script de creación inicial de la base de datos se hará una única vez, para ello, deberá hacer el diseño y tendrá derecho a dos chequeos con el profesor, una vez que tenga la versión estable proceda a generar el script de creación y subirlo a github, seguidamente todos los demás cambios a la DB, stored procedures, scripts y otros, deberá llevarlos con control de versiones haciendo uso de flyway.
5. Las siguientes tareas puede realizarlas en un solo script en múltiples archivos de script, se recomienda este último.
6. Script de llenado de la base de datos para la información catálogo que es necesaria para el funcionamiento de la base de datos.
7. Cree al menos dos vistas que sean útiles para el sistema, recuerde que las vistas son útiles cuando se requiere ver cierta información junta de varias tablas que el modelo relacional mantiene separadas.
8. Cree al menos 4 stored procedures que realicen operaciones de lectura que tengan sentido y sean útiles para el sistema y que dichos stored procedures hagan uso de las vistas.
9. Escriba dos stored procedure transaccionales, útiles para el sistema que haga escritura en al menos 3 tablas
10. Haga un select que cree una columna dinámica en una consulta cuya columna dinámica busque generar posibles grupos de datos, se recomienda la instrucción CASE.
11. Cree un stored procedure transaccional que llame dentro de la transacción a otro SP transaccional y este a otro SP que también sea transaccional. (De dos niveles). Cada stored procedure debe afectar al menos a dos tablas. Demuestre en este SP el funcionamiento del commit y el rollback, para probarlo tan solo se invoca con valores correctos y con valores incorrectos.
12. Cree un stored procedure que retorne el resultado de una consulta de al menos 3 tablas unidas en formato json.
13. Cree un stored procedure que inserte N registros en una tabla, tomando los datos correctamente identificados de una tabla temporal libre de restricciones que fue previamente llenada.
14. Ningun stored procedure debe recibir IDs por parámetro, siempre reciben nombres y con estos se averiguan los IDs dentro de los SPs.
15. Cree un(os) query(s) para cada una de los siguientes tipos de instrucciones y/o operadores de tal manera que se demuestre claramente su uso:
a. Uso de un cursor.
b. Uso de un trigger.
c. Un substring.
16. Una consulta que retorne un listado de los montos y personas, categorízados por año y mes de aquellos dineros que no se han podido cobrar, en el query debe poder verse las categorías, nombres y montos debidamente agrupados
17. Una consulta que retorne el volumen de operaciones de uso del sistema por mes en un rango de fechas, clasificado entre bajo volumen, volumen medio y volumen alto
18. API de lectura, proceda a implementar en nodejs un api utilizando REST sobre HTTP, el cuál debe tener mínimo routers, handlers y la implementación, para ello cree una única clase genérica que sea capaz de llamar a cualquier SP de la base de datos, las implementaciones hacen uso de dicha clase para hacer las llamadas específicas a los SPs, incluya en el API al menos los métodos necesarios para acceder a los 4 stored procedures de lectura, puede agregar más de ser necesario. El servidor de este backend debe ejecutarse como un container de Docker. Se recomienda el uso de un boilerplate existente.
19. API de escritura, proceda a implementar un API en Java, usando REST sobre HTTP, en este caso uselo para acceder a los SP transaccionales que implementó anteriormente, de la misma forma, cree una clase genérica que pueda acceder a la DB y llamar a cualquier SP, las clases de implementación son quienes saben las llamadas específicas.
20. Implemente un pequeño demo en kotlin si es una app mobile, o bien web, usando javascript puro, o reactJS, lo anterior depende de la aplicación que su grupo seleccionó. Dicho demo es de su aplicación y debe llamar únicamente aquellos métodos que las API ofrecen, recuerden que es un demo, la prioridad de este curso recae en la base de datos y su implementación, las apis y el demo son únicamente para demostrar el acceso y uso de la base de datos. Escoja con cuidado que SP implementar de tal forma que tengan sentido para el demo y las apis.
