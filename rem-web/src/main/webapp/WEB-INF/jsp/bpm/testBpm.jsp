<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>

<fwk:page>


 
  var crea = new Ext.Button({
  	text : 'Crear'
	,handler : 	function(){
    	page.submit({
      		flow : 'bpm/creaBpm'
	      ,formPanel : panelCrear
	      ,success : function(data){
        	token.setValue(data.tokenId);
      }
    });
  	}
	});
	var procedimiento = app.creaNumber('idProcedimiento', 'Procedimiento');


  var panelCrear = new Ext.form.FormPanel({
  	title : 'crear proceso jbpm'
	,width : '250px'
	,items : [procedimiento, crea]
	,autoHeight : true
	,style : 'margin:5px'
      });


  var token = app.creaText('tokenId','Token');
  var info = new Ext.Button({
  	text : 'info'
	,handler: function(){
		page.submit({
			flow: 'bpm/infoBpm',
			formPanel: panelSignal,
			success: function(data){
				infoLabel.body.update(data.result);
			}
		})
	}
  	});


  var infoLabel = new Ext.Panel({
  	autoHeight : true
	,html : ''
	,bodyStyle : 'padding : 5px'
  })

  var transitionName = app.creaText('transitionName', 'Transition name', 'avanzaBPM');
  var signal = new Ext.Button({
  	text : 'signal'
	,handler: function(){
	    page.submit({
	      flow : 'bpm/signalBpm'
	      ,formPanel : panelSignal
	      ,success : function(){
	      }
	  });
	}
  });

  var tokenMas1 = new Ext.Button({
  	text : 'token +1'
	,handler : function(){
		token.setValue(parseInt(token.getValue())+1);
	}
  })

  var panelSignal = new Ext.form.FormPanel({
  	title : 'señalizar proceso jbpm'
	,width : '250px'
    ,items : [token, transitionName, infoLabel, app.creaPanelH([info, signal, tokenMas1])]
	,autoHeight : true
      });

    var panel = new Ext.Panel({
    items : [ panelCrear, panelSignal]
	,bodyStyle : 'padding:10px'
	,autoHeight : true
      });

//panel = app.creaPanelH([panelCrear, panelSignal]);

  page.add(panel);

</fwk:page>