//package es.capgemini.devon.hibernate.test;
//
//import org.junit.Test;
//
///**
// * @author Nicol�s Cornaglia
// */
//public abstract class AbstractValidatingBatchLauncherTests extends AbstractBatchLauncherTests {
//
//    @Test
//    public void testLaunchJob() throws Exception {
//        try {
//            validatePreConditions();
//            jobExecution = super.launchJob();
//            validatePostConditions();
//        } catch (Exception e) {
//            throw e;
//        } finally {
//            cleanUp();
//        }
//    }
//
//    /**
//     * Make sure input data meets expectations
//     */
//    protected void validatePreConditions() throws Exception {
//    }
//
//    /**
//     * Make sure job did what it was expected to do.
//     */
//    protected abstract void validatePostConditions() throws Exception;
//
//    /**
//     * Cleans the tests temps
//     */
//    protected void cleanUp() throws Exception {
//
//    }
//
//}
