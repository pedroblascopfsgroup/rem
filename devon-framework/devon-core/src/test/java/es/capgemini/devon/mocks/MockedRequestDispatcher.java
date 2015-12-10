package es.capgemini.devon.mocks;

import java.io.IOException;
import java.io.OutputStream;
import java.util.Enumeration;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

/**
 * <b>Descripcion:</b></p>
 * <p/>
 * <b>Dependencias:</b></p>
 * <p/>
 * <b>Configuracion:</b></p>
 * <p/>
 * Date: Nov 8, 2005
 * Time: 9:17:10 PM
 */
public class MockedRequestDispatcher implements RequestDispatcher {

    private final static char[] __CRLF = "\r\n".toCharArray();

    public MockedRequestDispatcher() {
    }

    public void include(ServletRequest servletRequest, ServletResponse servletResponse) throws ServletException, IOException {
        forward(servletRequest, servletResponse);
    }

    public void forward(ServletRequest servletRequest, ServletResponse servletResponse) throws ServletException, IOException {

        StringBuffer buffer = new StringBuffer();

        buffer.append("<html>").append(__CRLF, 0, __CRLF.length);
        buffer.append("<head>").append(__CRLF, 0, __CRLF.length);
        buffer.append("<head><title>Test Page</title></head>").append(__CRLF, 0, __CRLF.length);
        buffer.append("</head>").append(__CRLF, 0, __CRLF.length);
        buffer.append("<body>").append(__CRLF, 0, __CRLF.length);
        buffer.append("<table>").append(__CRLF, 0, __CRLF.length);

        writeValues(servletRequest, buffer);

        writeAttributeValues(servletRequest, buffer);

        if (servletRequest instanceof HttpServletRequest) {
            HttpSession session = ((HttpServletRequest) servletRequest).getSession(false);
            if (session != null) {
                writeSessionValues(session, buffer);
            }
        }

        buffer.append("</table>").append(__CRLF, 0, __CRLF.length);
        buffer.append("</body>").append(__CRLF, 0, __CRLF.length);
        buffer.append("</html>").append(__CRLF, 0, __CRLF.length);

        byte[] output = buffer.toString().getBytes();
        OutputStream os = servletResponse.getOutputStream();
        os.write(output, 0, output.length);
        os.flush();
        os.close();
    }

    private void writeValues(ServletRequest request, StringBuffer buffer) {

        Enumeration e = request.getParameterNames();
        String param;

        while (e.hasMoreElements()) {
            param = (String) e.nextElement();
            buffer.append("<tr>").append(__CRLF, 0, __CRLF.length);
            buffer.append("<td align=\"rigth\">").append(param).append("</td>").append("<td align=\"rigth\">").append(request.getParameter(param))
                    .append("</td>").append(__CRLF, 0, __CRLF.length);
            buffer.append("</tr>").append(__CRLF, 0, __CRLF.length);
        }

    }

    private void writeAttributeValues(ServletRequest request, StringBuffer buffer) {

        Enumeration e = request.getAttributeNames();
        String param;

        while (e.hasMoreElements()) {
            param = (String) e.nextElement();
            buffer.append("<tr>").append(__CRLF, 0, __CRLF.length);
            buffer.append("<td align=\"rigth\">").append(param).append("</td>").append("<td align=\"rigth\">").append(request.getAttribute(param))
                    .append("</td>").append(__CRLF, 0, __CRLF.length);
            buffer.append("</tr>").append(__CRLF, 0, __CRLF.length);
        }

    }

    private void writeSessionValues(HttpSession session, StringBuffer buffer) {

        Enumeration e = session.getAttributeNames();
        String param;

        while (e.hasMoreElements()) {
            param = (String) e.nextElement();
            buffer.append("<tr>").append(__CRLF, 0, __CRLF.length);
            buffer.append("<td align=\"rigth\">").append(param).append("</td>").append("<td align=\"rigth\">").append(session.getAttribute(param))
                    .append("</td>").append(__CRLF, 0, __CRLF.length);
            buffer.append("</tr>").append(__CRLF, 0, __CRLF.length);
        }

    }

}
