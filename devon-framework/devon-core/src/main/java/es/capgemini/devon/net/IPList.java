package es.capgemini.devon.net;

import java.net.InetAddress;
import java.net.UnknownHostException;
import java.util.LinkedList;
import java.util.List;

/**
 * A mutable list of IP addresses.  More specifically, a list of sets of
 * addresses, like "18.239.0.*".  Provides fast operations to find if an address
 * is in the list.  Used to implement IPFilter.  Not synchronized.
 *
 * @author Gregorio Roper 
 */
public class IPList {
    /** The list of IP's. */
    private List<IP> /* of IP */ips = new LinkedList<IP>();

    public IPList() {
    }

    /** 
     * Adds a certain IP to the IPList.
     * @param ip_str a String containing the IP, see IP.java for formatting
     */
    public void add(String ip_str) {
        IP ip;
        try {
            ip = getIP(ip_str);
        } catch (IllegalArgumentException e) {
            return;
        }

        if (!ips.contains(ip)) {// don't add the same IP more than once
            ips.add(ip);
        }
    }

    /**
     * @param String equal to an IP
     * @returns true if ip_address is contained somewhere in the list of IPs
     */
    public boolean contains(IP ip) {
        for (IP pattern : ips) {
            if (pattern.contains(ip))
                return true;
        }
        return false;
    }

    public static IP getIP(String host) {
        IP ip;
        try {
            ip = new IP(host);
        } catch (IllegalArgumentException badHost) {
            try {
                InetAddress lookUp = InetAddress.getByName(host);
                host = lookUp.getHostAddress();
                ip = new IP(host);
            } catch (UnknownHostException unknownHost) {
                // could not look up this host.
                return null;
            } catch (IllegalArgumentException stillBadHost) {
                // couldn't construct IP still.
                return null;
            }
        }
        return ip;
    }
}
