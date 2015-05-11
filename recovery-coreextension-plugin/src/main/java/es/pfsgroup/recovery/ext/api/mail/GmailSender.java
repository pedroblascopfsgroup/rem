package es.pfsgroup.recovery.ext.api.mail;

import org.springframework.mail.MailException;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.MimeMessageHelper;

public interface GmailSender {

	void send(MimeMessageHelper messageHelper) throws MailException;
}
