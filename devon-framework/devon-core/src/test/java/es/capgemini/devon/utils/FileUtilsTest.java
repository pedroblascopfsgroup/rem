package es.capgemini.devon.utils;

import java.io.File;
import java.util.Map;

import junit.framework.TestCase;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;

/**
 * TODO Documentar
 * 
 * @author Nicolás Cornaglia
 */
public class FileUtilsTest extends TestCase {

    private static String pattern = "[0-9][0-9][0-9][0-9]";
    private static String path = "c:/tmp/FileUtilsTest";

    private File dir;

    /**
     * @throws java.lang.Exception
     */
    @Override
    @Before
    public void setUp() throws Exception {
        dir = new File(path);
        dir.mkdirs();
    }

    /**
     * @throws java.lang.Exception
     */
    @Override
    @After
    public void tearDown() throws Exception {
        FileUtils.deleteDir(new File(path));
    }

    @Test
    public void testBaseDoesntExist() {
        File dir1 = new File(path + "/noexist");

        Map<String, String> dirs = FileUtils.generateDirectories(dir1, pattern, "", null);
        assertTrue("Dir is not empty", dirs.isEmpty());
    }

    @Test
    public void testBaseExistEmpty() {
        Map<String, String> dirs = FileUtils.generateDirectories(dir, pattern, "", null);
        assertTrue("Dir is not empty", dirs.isEmpty());
    }

    @Test
    public void testOneFile() {
        (new File(path + "/1111")).mkdirs();

        Map<String, String> dirs = FileUtils.generateDirectories(dir, pattern, "", null);
        assertTrue(dirs.size() == 1);

        for (String gdir : dirs.values()) {
            assertFileExists(gdir);
        }
    }

    @Test
    public void testPattern() {
        (new File(path + "/1111")).mkdirs();
        (new File(path + "/111")).mkdirs();

        Map<String, String> dirs = FileUtils.generateDirectories(dir, pattern, "", null);
        assertTrue(dirs.size() == 1);

        for (String gdir : dirs.values()) {
            assertFileExists(gdir);
        }
    }

    @Test
    public void testTwoFiles() {
        (new File(path + "/1111")).mkdirs();
        (new File(path + "/1112")).mkdirs();

        Map<String, String> dirs = FileUtils.generateDirectories(dir, pattern, "", null);
        assertTrue(dirs.size() == 2);

        for (String gdir : dirs.values()) {
            assertFileExists(gdir);
        }
    }

    @Test
    public void testOneFileSuffix() {
        (new File(path + "/1111")).mkdirs();

        Map<String, String> dirs = FileUtils.generateDirectories(dir, pattern, "trade/in", null);
        assertTrue(dirs.size() == 1);

        for (String gdir : dirs.values()) {
            assertFileExists(gdir);
            assertEquals("Filename not as espected", path + "/1111/trade/in", gdir);
        }
    }

    // -------------------------------------------------------------

    private void assertFileExists(String path) {
        File f = new File(path);
        assertTrue("File must exists", f.exists());
    }

}
