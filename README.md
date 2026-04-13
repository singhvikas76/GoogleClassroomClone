# Virtual Classroom & Assignment Upload System

A Java-based web application serving as a virtual classroom and assignment upload platform (similar to Google Classroom). This application allows seamless interaction between users through classes, posts, and comments.

## Features

*   **User Authentication**: Register and login functionality for users.
*   **Class Management**:
    *   Create new classes.
    *   Join existing classes.
    *   View joined and created classes on a personalized dashboard.
*   **Discussion & Posts**:
    *   Create posts and upload assignments within a class.
    *   Update and delete posts.
*   **Interactive Comments**: Add and delete comments on posts within the classroom.
*   **Modern UI**: Features a clean, responsive, and minimal user interface with beautiful aesthetics.

## Tech Stack

*   **Frontend**: HTML, CSS, JavaScript, JSP (JavaServer Pages)
*   **Backend**: Java (Servlets, JDBC)
*   **Database**: MySQL
*   **Server**: Apache Tomcat Server

## Prerequisites

*   Java Development Kit (JDK) 8 or higher
*   Eclipse IDE for Enterprise Java Web Developers
*   Apache Tomcat (v8.5 or higher recommended)
*   XAMPP or MySQL Server

## Installation and Setup

1.  **Clone or Download**: Download this repository and import it into Eclipse IDE as a "Dynamic Web Project".
2.  **Database Setup**:
    *   Start Apache and MySQL using XAMPP control panel.
    *   Open phpMyAdmin or your preferred MySQL client.
    *   Create a new database named `classroom_db`.
3.  **Database Configuration**:
    *   Navigate to `src/main/java/dao/DBConnection.java`.
    *   Verify the database connection strings and credentials.
    *   *Default configuration uses `jdbc:mysql://localhost:3307/classroom_db`. If your MySQL runs on the default port, change `3307` to `3306` inside this file.*
    *   Default username is `root`, and password is `""` (empty string). Update these if needed.
4.  **Run the Application**:
    *   Add the project to your configured Apache Tomcat Server in Eclipse.
    *   Right-click the project -> **Run As** -> **Run on Server**.
    *   The application will launch in your browser (typically starting at `index.jsp` or `dashboard.jsp`).

## Folder Structure

*   `src/main/java/controller/`: Contains Servlet classes handling HTTP requests (Login, Register, Posts, Comments, etc.).
*   `src/main/java/dao/`: Contains the database connection utility (`DBConnection.java`).
*   `src/main/java/model/`: Contains Java beans / Data models.
*   `src/main/webapp/`: Contains all frontend views (JSP pages), static assets, and `WEB-INF`.
