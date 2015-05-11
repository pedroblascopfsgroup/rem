package es.pfsgroup.recovery.bpmframework.test.bpm.RecoveryBPMFwkInputJbpmCallback;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;
import static org.mockito.Mockito.reset;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.Random;

import org.apache.commons.lang.RandomStringUtils;
import org.jbpm.JbpmContext;
import org.jbpm.context.exe.ContextInstance;
import org.jbpm.db.GraphSession;
import org.jbpm.graph.def.Node;
import org.jbpm.graph.def.Transition;
import org.jbpm.graph.exe.ProcessInstance;
import org.jbpm.graph.exe.Token;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.ArgumentCaptor;
import org.mockito.Mock;
import org.mockito.runners.MockitoJUnitRunner;

import es.pfsgroup.recovery.bpmframework.bpm.RecoveryBPMFwkInputJbpmCallback;
import es.pfsgroup.recovery.bpmframework.input.model.RecoveryBPMfwkInput;

@RunWith(MockitoJUnitRunner.class)
public class DoInJbpmTest {

    private RecoveryBPMFwkInputJbpmCallback callback;

    private Long idProcess;

    private String transitionName;

    private Long idInput;

    private String dateFormated;

    @Mock
    private RecoveryBPMfwkInput mockInput;

    @Mock
    private JbpmContext mockJbpmContext;

    @Mock
    private GraphSession mockGraphSession;

    @Mock
    private ProcessInstance mockProcessInstance;

    @Mock
    private ContextInstance mockContextInstance;

    private List<Token> listOfMockForTokens;

    @Mock
    private Token notMatchingMockToken;

    @Mock
    private Token matchingMockToken;

    @Mock
    private Token anotherNotMatchingMockToken;

    @Mock
    private Token anotherMatchingMockToken;

    @Mock
    private Node notMatchingNodeMock;

    @Mock
    private Node matchingNodeMock;

    @Mock
    private Node anotherNotMatchingNodeMock;

    @Mock
    private Node anotherMatchingNodeMock;

    @Mock
    private Transition mockTransition;

    private String matchingNodeName;

    private String anotherMatchingNodeName;

    @Before
    public void before() {
        Random random = new Random();
        idProcess = random.nextLong();
        transitionName = RandomStringUtils.random(100);
        idInput = random.nextLong();
        dateFormated = new SimpleDateFormat("yyyyMMddhhmmss").format(new Date());

        callback = new RecoveryBPMFwkInputJbpmCallback(idProcess, transitionName, mockInput);
        when(mockInput.getId()).thenReturn(idInput);

        listOfMockForTokens = new ArrayList<Token>();
        listOfMockForTokens.add(notMatchingMockToken);
        listOfMockForTokens.add(matchingMockToken);
        listOfMockForTokens.add(anotherNotMatchingMockToken);
        listOfMockForTokens.add(anotherMatchingMockToken);

        when(notMatchingMockToken.getNode()).thenReturn(notMatchingNodeMock);
        when(matchingMockToken.getNode()).thenReturn(matchingNodeMock);
        when(anotherNotMatchingMockToken.getNode()).thenReturn(anotherNotMatchingNodeMock);
        when(anotherMatchingMockToken.getNode()).thenReturn(anotherMatchingNodeMock);

        when(notMatchingNodeMock.getLeavingTransition(transitionName)).thenReturn(null);
        when(anotherNotMatchingNodeMock.getLeavingTransition(transitionName)).thenReturn(null);

        when(matchingNodeMock.getLeavingTransition(transitionName)).thenReturn(mockTransition);
        when(anotherMatchingNodeMock.getLeavingTransition(transitionName)).thenReturn(mockTransition);

        matchingNodeName = RandomStringUtils.randomAlphabetic(100);
        anotherMatchingNodeName = RandomStringUtils.randomAlphabetic(100);

        when(matchingNodeMock.getName()).thenReturn(matchingNodeName);
        when(anotherMatchingNodeMock.getName()).thenReturn(anotherMatchingNodeName);
    }

    @After
    public void after() {
        idProcess = null;
        transitionName = null;
        idInput = null;
        dateFormated = null;

        reset(mockJbpmContext);
        reset(mockGraphSession);
        reset(mockInput);
        reset(mockProcessInstance);
        reset(mockContextInstance);

        listOfMockForTokens = null;

        reset(notMatchingMockToken);
        reset(matchingMockToken);
        reset(anotherNotMatchingMockToken);
        reset(anotherMatchingMockToken);

        reset(notMatchingNodeMock);
        reset(matchingNodeMock);
        reset(anotherNotMatchingNodeMock);
        reset(anotherMatchingNodeMock);

        reset(mockTransition);

        anotherMatchingNodeName = null;
        matchingNodeName = null;
    }

    @SuppressWarnings("rawtypes")
	@Test
    public void testDoInJbpm() {

        when(mockJbpmContext.getGraphSession()).thenReturn(mockGraphSession);
        when(mockGraphSession.getProcessInstance(idProcess)).thenReturn(mockProcessInstance);
        when(mockProcessInstance.isTerminatedImplicitly()).thenReturn(Boolean.FALSE);

        when(mockProcessInstance.findAllTokens()).thenReturn(listOfMockForTokens);
        when(mockProcessInstance.getContextInstance()).thenReturn(mockContextInstance);

        callback.doInJbpm(mockJbpmContext);

        verify(matchingMockToken, times(1)).signal(transitionName);
        verify(anotherMatchingMockToken, times(1)).signal(transitionName);

        final ArgumentCaptor<Map> argumentCaptor = ArgumentCaptor.forClass(Map.class);
        verify(mockContextInstance, times(1)).setVariables(argumentCaptor.capture());

        final Map argument = argumentCaptor.getValue();
        assertNotNull(argument.get(matchingNodeName + "." + transitionName + "." + dateFormated + ".input"));
        assertNotNull(argument.get(anotherMatchingNodeName + "." + transitionName + "." + dateFormated + ".input"));

        assertEquals(idInput, argument.get(matchingNodeName + "." + transitionName + "." + dateFormated + ".input"));
        assertEquals(idInput, argument.get(anotherMatchingNodeName + "." + transitionName + "." + dateFormated + ".input"));

    }

}
