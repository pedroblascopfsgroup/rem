//package es.capgemini.devon.mail;
//
//import java.util.HashMap;
//import java.util.Map;
//
//import org.apache.velocity.app.VelocityEngine;
//import org.junit.BeforeClass;
//import org.junit.Test;
//import org.springframework.core.io.ClassPathResource;
//import org.springframework.mail.javamail.MimeMessageHelper;
//import org.springframework.ui.velocity.VelocityEngineFactoryBean;
//
///**
// * @author Nicol�s Cornaglia
// */
// FIXME Estos tests no pasan
//public class MailManagerTest {
//
//    private static MailManager mailManager;
//
//    @BeforeClass
//    public static void setUpBefore() throws Exception {
//        mailManager = new MailManagerImpl();
//        mailManager.setHost("smtp.capgemini.es");
//
//        String path = new ClassPathResource("es/capgemini/devon/mail").getFile().getAbsolutePath();
//
//        VelocityEngineFactoryBean vefb = new VelocityEngineFactoryBean();
//        vefb.setResourceLoaderPath("file:/" + path);
//        vefb.afterPropertiesSet();
//        VelocityEngine ve = (VelocityEngine) vefb.getObject();
//
//        ((MailManagerImpl) mailManager).setVelocityEngine(ve);
//    }
//
//    @Test
//    public void testSendPlain() throws Exception {
//        MimeMessageHelper helper = mailManager.createMimeMessageHelper();
//
//        helper.setSubject("Devon mail service test");
//        helper.setTo("ncornagl@capgemini.com");
//        helper.setText("<html><body>Correo <b>Plano</b><body><html>");
//
//        mailManager.send(helper);
//
//    }
//
//    @Test
//    public void testSendHtml() throws Exception {
//        MimeMessageHelper helper = mailManager.createMimeMessageHelper();
//
//        helper.setSubject("Devon mail service test");
//        helper.setTo("ncornagl@capgemini.com");
//        helper.setText("<html><body>Correo <b>HTML</b><body><html>", true);
//
//        mailManager.send(helper);
//    }
//
//    @Test
//    public void testSendAttachment() throws Exception {
//        MimeMessageHelper helper = mailManager.createMimeMessageHelper(true);
//
//        helper.setSubject("Devon mail service test");
//        helper.setTo("ncornagl@capgemini.com");
//        helper.setText("<html><body>Correo <b>Attachment</b><body><html>", true);
//
//        helper.addAttachment("Bariloche.jpg", new ClassPathResource("bariloche.jpg"));
//
//        mailManager.send(helper);
//
//    }
//
//    @Test
//    public void testSendInline() throws Exception {
//        MimeMessageHelper helper = mailManager.createMimeMessageHelper(true);
//
//        helper.setSubject("Devon mail service test");
//        helper.setTo("ncornagl@capgemini.com");
//        helper.setText("<html><body>Correo <b>Inline</b>:<img src='cid:identifier1234'><body><html>", true);
//
//        helper.addInline("identifier1234", new ClassPathResource("bariloche.jpg"));
//
//        mailManager.send(helper);
//    }
//
//    @SuppressWarnings("unchecked")
//    @Test
//    public void testSendTemplate() throws Exception {
//        MimeMessageHelper helper = mailManager.createMimeMessageHelper();
//
//        helper.setSubject("Devon mail service test");
//        helper.setTo("ncornagl@capgemini.com");
//
//        Map model = new HashMap();
//        model.put("userData", "userVariableData");
//
//        helper.setText(mailManager.mergeTemplateIntoString("template.vm", model));
//
//        mailManager.send(helper);
//
//    }
//}
