var tb = new Ext.Toolbar();
tb.render('toolbar');


<c:forEach  var="item" items="${menu}" varStatus="status">
tb.add(<app:menu menu="${item}" />);
</c:forEach> 


/**
 * funcion para abrir pantallas de Tareas WorkFlow
 * @param {} tipo
 */
var abrePantallaWf=function(tipo){
	var w = app.openWindow({
		flow : 'fase2/expedientes/tareas_wf/tareas_wf'
		,width:320
		,closable:true
		//,title : '<s:message code="app.acercade" text="**Excluir Clientes del Expediente" />'
		,params:{tipoWf:tipo}
		
	});
	w.on(app.event.DONE, function(){
		w.close();
	});
	w.on(app.event.CANCEL, function(){
		w.close();
	});
}




//ext3.0
tb.doLayout();