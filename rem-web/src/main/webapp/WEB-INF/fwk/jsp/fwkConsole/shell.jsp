<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>


<fwk:page>
var command = new Ext.form.TextArea({
			fieldLabel:'script'
			,width:600
            ,height : 100
			,name: 'script'
            ,enableKeyEvents : true
			,style : 'font-family:courier'
		});
var result = new Ext.form.TextArea({
			fieldLabel:'result'
			,width:600
            ,height : 200
			,style : 'font-family:courier'
		});

	var boton = new Ext.Button({
		text : 'Ejecutar'
		//,handler:
	});



var hist = Ext.data.Record.create([
		{name : 'script'}
		,{name:'result'}
	]);

	var data = { hist :[] };

	var histStore = new Ext.data.JsonStore({
		fields : ['script','result']
		,root : 'hist'
		,data : data
	});

	var taller=function(value){
		return "<div style='height:100px;width:200px;white-space:normal'>"+value+"</div>";
	};
	var cm = new Ext.grid.ColumnModel(
		[{dataIndex : 'script', header : 'script', renderer :taller, width:200}
		,{dataIndex : 'result', header : 'result', renderer : taller, width:200}
	]);
	var history = new Ext.grid.GridPanel({
		cm : cm
		,store : histStore
		,id : 'hist'
		,width : 420
        ,height: 400
	});

    var submit =    function(){
			page.submit({
				//eventName : 'eval'
				flow : 'shell/eval' //FIXME: Esto no es mas un flow...
				,formPanel : panel
				,success : function(data){
					result.setValue(data.result);
					histStore.loadData({hist:[{script:command.getValue(), result : result.getValue()}]},true);
				}
			});
    };

	boton.on('click', submit);
	

	var panel	= new Ext.FormPanel({
		autoHeight : true
		,autoWidth:true
		,bodyStyle : 'padding:10px'
		,border : false
		,items : [command, boton, result, history]
	});
	
    //var p    = app.creaPanelH(panel, history);

	page.add(panel);

</fwk:page>
