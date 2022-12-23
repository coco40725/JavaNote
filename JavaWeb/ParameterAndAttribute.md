## The different between Parameter and Attribute

### 1. Parameter
a parameter is a string value that is most commonly known for **being sent from the client to the server** (e.g. a form post) and retrieved from the servlet request. 

- **ServletContext (application scope)**:
    - no methods for parameters
- **HttpSession (session scope)**:
    - no methods for parameters
- **ServletRequest (request scope)**:
    - getParameter()
    - setParameter()
    - getParameterNames()
    - getParameterValue()
-  **PageContext (page scope)**:
    - no methods for parameters


### 2. Attribute
an attribute is for server-side usage only - you fill the request with attributes that you can use within the same request.

- **ServletContext (application scope)**:
    - getAttribute()
    - setAttribute()
- **HttpSession (session scope)**:
    - getAttribute()
    - setAttribute()
- **ServletRequest (request scope)**:
    - getAttribute()
    - setAttribute()
-  **PageContext (page scope)**:
    - getAttribute()
    - setAttribute()


### 3. Scope
There are four common Scopes as following:
- **application**, available for the life of the entire application
    - `javax.servlet.ServletContext`
- **session**, available for the life of the session
    - `javax.servlet.http.HttpSession`
- **request**, only available for the life of the request
    - subclass of `javax.servlet.ServletRequest`
- **page (JSP only)**, available for the current JSP page only
    - `javax.servlet.jsp.PageContext`
    - `javax.servlet.jsp.JspWriter`
    - subclass of `javax.servlet.ServletResponse`

