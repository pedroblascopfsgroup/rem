package es.capgemini.devon.utils.socketProxy;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.Socket;

/**
 * @author lgiavedo
 *
 */
public class ProxyThread extends Thread {
    Socket incoming, outgoing;

    //Thread constructor

    ProxyThread(Socket in, Socket out) {
        incoming = in;
        outgoing = out;
    }

    @Override
    public void run() {
        byte[] buffer = new byte[60];
        int numberRead = 0;
        OutputStream ToClient;
        InputStream FromClient;
        StringBuffer out = new StringBuffer();
        byte[] b = new byte[4096];

        try {
            ToClient = outgoing.getOutputStream();
            FromClient = incoming.getInputStream();
            while (true) {
                numberRead = FromClient.read(buffer, 0, 50);

                if (numberRead == -1) {
                    incoming.close();
                    outgoing.close();
                }

                ToClient.write(buffer, 0, numberRead);
                System.out.print(new String(buffer));
            }

        } catch (IOException e) {
            System.out.println(e);
        } catch (ArrayIndexOutOfBoundsException e) {
            System.out.println(e);
        }

    }

}
