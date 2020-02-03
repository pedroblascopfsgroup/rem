package es.pfsgroup.plugin.rem.jbpm.handler;

import java.io.IOException;

import javax.annotation.Resource;

import org.jbpm.graph.exe.ExecutionContext;
import org.springframework.mail.javamail.MimeMessageHelper;

import es.capgemini.devon.mail.MailManager;

public class ActivoGenericEnterEmailActionHandler extends ActivoGenericEnterActionHandler {

	private static final long serialVersionUID = -2997523481794698821L;

	@Resource(name = "mailManager")
	private MailManager mailManager;

	/**
	 * PONER JAVADOC FO.
	 * 
	 * @param delegateTransitionClass
	 *            delegateTransitionClass
	 * @param delegateSpecificClass
	 *            delegateSpecificClass
	 * @throws Exception
	 */
	@Override
	protected void process(Object delegateTransitionClass, Object delegateSpecificClass, ExecutionContext executionContext) throws Exception {
	
		super.process(delegateTransitionClass, delegateSpecificClass, executionContext);
		
		MimeMessageHelper helper = mailManager.createMimeMessageHelper();
		helper.setFrom("daniel.gutierrez@pfsgroup.es");
		helper.setTo("daniel.gutierrez@pfsgroup.es");
		helper.setSubject("prueba de correo");
		helper.setText("cuerpo de correo", true);


		mailManager.send(helper);

	}
	
	private void writeObject(java.io.ObjectOutputStream out) throws IOException {
		//empty
	}

	private void readObject(java.io.ObjectInputStream in) throws IOException, ClassNotFoundException {
		//empty
	}
}