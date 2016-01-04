/*!
 * Ext JS Library 3.0.0
 * Copyright(c) 2006-2009 Ext JS, LLC
 * licensing@extjs.com
 * http://www.extjs.com/license
 */
/**
 * @class Ext.DomHelper
 * <p>The DomHelper class provides a layer of abstraction from DOM and transparently supports creating
 * elements via DOM or using HTML fragments. It also has the ability to create HTML fragment templates
 * from your DOM building code.</p>
 *
 * <p><b><u>DomHelper element specification object</u></b></p>
 * <p>A specification object is used when creating elements. Attributes of this object
 * are assumed to be element attributes, except for 4 special attributes:
 * <div class="mdetail-params"><ul>
 * <li><b><tt>tag</tt></b> : <div class="sub-desc">The tag name of the element</div></li>
 * <li><b><tt>children</tt></b> : or <tt>cn</tt><div class="sub-desc">An array of the
 * same kind of element definition objects to be created and appended. These can be nested
 * as deep as you want.</div></li>
 * <li><b><tt>cls</tt></b> : <div class="sub-desc">The class attribute of the element.
 * This will end up being either the "class" attribute on a HTML fragment or className
 * for a DOM node, depending on whether DomHelper is using fragments or DOM.</div></li>
 * <li><b><tt>html</tt></b> : <div class="sub-desc">The innerHTML for the element</div></li>
 * </ul></div></p>
 *
 * <p><b><u>Insertion methods</u></b></p>
 * <p>Commonly used insertion methods:
 * <div class="mdetail-params"><ul>
 * <li><b><tt>{@link #append}</tt></b> : <div class="sub-desc"></div></li>
 * <li><b><tt>{@link #insertBefore}</tt></b> : <div class="sub-desc"></div></li>
 * <li><b><tt>{@link #insertAfter}</tt></b> : <div class="sub-desc"></div></li>
 * <li><b><tt>{@link #overwrite}</tt></b> : <div class="sub-desc"></div></li>
 * <li><b><tt>{@link #createTemplate}</tt></b> : <div class="sub-desc"></div></li>
 * <li><b><tt>{@link #insertHtml}</tt></b> : <div class="sub-desc"></div></li>
 * </ul></div></p>
 *
 * <p><b><u>Example</u></b></p>
 * <p>This is an example, where an unordered list with 3 children items is appended to an existing
 * element with id <tt>'my-div'</tt>:<br>
 <pre><code>
var dh = Ext.DomHelper; // create shorthand alias
// specification object
var spec = {
    id: 'my-ul',
    tag: 'ul',
    cls: 'my-list',
    // append children after creating
    children: [     // may also specify 'cn' instead of 'children'
        {tag: 'li', id: 'item0', html: 'List Item 0'},
        {tag: 'li', id: 'item1', html: 'List Item 1'},
        {tag: 'li', id: 'item2', html: 'List Item 2'}
    ]
};
var list = dh.append(
    'my-div', // the context element 'my-div' can either be the id or the actual node
    spec      // the specification object
);
 </code></pre></p>
 * <p>Element creation specification parameters in this class may also be passed as an Array of
 * specification objects. This can be used to insert multiple sibling nodes into an existing
 * container very efficiently. For example, to add more list items to the example above:<pre><code>
dh.append('my-ul', [
    {tag: 'li', id: 'item3', html: 'List Item 3'},
    {tag: 'li', id: 'item4', html: 'List Item 4'}
]);
 * </code></pre></p>
 *
 * <p><b><u>Templating</u></b></p>
 * <p>The real power is in the built-in templating. Instead of creating or appending any elements,
 * <tt>{@link #createTemplate}</tt> returns a Template object which can be used over and over to
 * insert new elements. Revisiting the example above, we could utilize templating this time:
 * <pre><code>
// create the node
var list = dh.append('my-div', {tag: 'ul', cls: 'my-list'});
// get template
var tpl = dh.createTemplate({tag: 'li', id: 'item{0}', html: 'List Item {0}'});

for(var i = 0; i < 5, i++){
    tpl.append(list, [i]); // use template to append to the actual node
}
 * </code></pre></p>
 * <p>An example using a template:<pre><code>
var html = '<a id="{0}" href="{1}" class="nav">{2}</a>';

var tpl = new Ext.DomHelper.createTemplate(html);
tpl.append('blog-roll', ['link1', 'http://www.jackslocum.com/', "Jack&#39;s Site"]);
tpl.append('blog-roll', ['link2', 'http://www.dustindiaz.com/', "Dustin&#39;s Site"]);
 * </code></pre></p>
 *
 * <p>The same example using named parameters:<pre><code>
var html = '<a id="{id}" href="{url}" class="nav">{text}</a>';

var tpl = new Ext.DomHelper.createTemplate(html);
tpl.append('blog-roll', {
    id: 'link1',
    url: 'http://www.jackslocum.com/',
    text: "Jack&#39;s Site"
});
tpl.append('blog-roll', {
    id: 'link2',
    url: 'http://www.dustindiaz.com/',
    text: "Dustin&#39;s Site"
});
 * </code></pre></p>
 *
 * <p><b><u>Compiling Templates</u></b></p>
 * <p>Templates are applied using regular expressions. The performance is great, but if
 * you are adding a bunch of DOM elements using the same template, you can increase
 * performance even further by {@link Ext.Template#compile "compiling"} the template.
 * The way "{@link Ext.Template#compile compile()}" works is the template is parsed and
 * broken up at the different variable points and a dynamic function is created and eval'ed.
 * The generated function performs string concatenation of these parts and the passed
 * variables instead of using regular expressions.
 * <pre><code>
var html = '<a id="{id}" href="{url}" class="nav">{text}</a>';

var tpl = new Ext.DomHelper.createTemplate(html);
tpl.compile();

//... use template like normal
 * </code></pre></p>
 *
 * <p><b><u>Performance Boost</u></b></p>
 * <p>DomHelper will transparently create HTML fragments when it can. Using HTML fragments instead
 * of DOM can significantly boost performance.</p>
 * <p>Element creation specification parameters may also be strings. If {@link #useDom} is <tt>false</tt>,
 * then the string is used as innerHTML. If {@link #useDom} is <tt>true</tt>, a string specification
 * results in the creation of a text node. Usage:</p>
 * <pre><code>
Ext.DomHelper.useDom = true; // force it to use DOM; reduces performance
 * </code></pre>
 * @singleton
 */
Ext.DomHelper = function(){
    var tempTableEl = null,
    	emptyTags = /^(?:br|frame|hr|img|input|link|meta|range|spacer|wbr|area|param|col)$/i,
    	tableRe = /^table|tbody|tr|td$/i,
    	pub,
    	// kill repeat to save bytes
    	afterbegin = "afterbegin",
    	afterend = "afterend",
    	beforebegin = "beforebegin",
    	beforeend = "beforeend",
    	ts = '<table>',
        te = '</table>',
        tbs = ts+'<tbody>',
        tbe = '</tbody>'+te,
        trs = tbs + '<tr>',
        tre = '</tr>'+tbe;

    // private
    function doInsert(el, o, returnElement, pos, sibling, append){
        var newNode = pub.insertHtml(pos, Ext.getDom(el), createHtml(o));
        return returnElement ? Ext.get(newNode, true) : newNode;
    }

    // build as innerHTML where available
    function createHtml(o){
	    var b = "",
	    	attr,
	    	val,
	    	key,
	    	keyVal,
	    	cn;

        if(typeof o == 'string'){
            b = o;
        } else if (Ext.isArray(o)) {
	        Ext.each(o, function(v) {
                b += createHtml(v);
            });
        } else {
	        b += "<" + (o.tag = o.tag || "div");
            Ext.iterate(o, function(attr, val){
                if(!/tag|children|cn|html$/i.test(attr)){
                    if (Ext.isObject(val)) {
                        b += " " + attr + "='";
                        Ext.iterate(val, function(key, keyVal){
                            b += key + ":" + keyVal + ";";
                        });
                        b += "'";
                    }else{
                        b += " " + ({cls : "class", htmlFor : "for"}[attr] || attr) + "='" + val + "'";
                    }
                }
            });
	        // Now either just close the tag or try to add children and close the tag.
	        if (emptyTags.test(o.tag)) {
	            b += "/>";
	        } else {
	            b += ">";
	            if ((cn = o.children || o.cn)) {
	                b += createHtml(cn);
	            } else if(o.html){
	                b += o.html;
	            }
	            b += "</" + o.tag + ">";
        	}
        }
        return b;
    }

    function ieTable(depth, s, h, e){
        tempTableEl.innerHTML = [s, h, e].join('');
        var i = -1,
        	el = tempTableEl;
        while(++i < depth){
            el = el.firstChild;
        }
        return el;
    }

    /**
     * @ignore
     * Nasty code for IE's broken table implementation
     */
    function insertIntoTable(tag, where, el, html) {
	    var node,
        	before;

        tempTableEl = tempTableEl || document.createElement('div');

  	    if(tag == 'td' && (where == afterbegin || where == beforeend) ||
  	       !/td|tr|tbody/i.test(tag) && (where == beforebegin || where == afterend)) {
            return;
        }
        before = where == beforebegin ? el :
		 		 where == afterend ? el.nextSibling :
				 where == afterbegin ? el.firstChild : null;

        if (where == beforebegin || where == afterend) {
        	el = el.parentNode;
    	}

        if (tag == 'td' || (tag == "tr" && (where == beforeend || where == afterbegin))) {
	        node = ieTable(4, trs, html, tre);
        } else if ((tag == "tbody" && (where == beforeend || where == afterbegin)) ||
        		   (tag == "tr" && (where == beforebegin || where == afterend))) {
	        node = ieTable(3, tbs, html, tbe);
        } else {
	     	node = ieTable(2, ts, html, te);
        }
        el.insertBefore(node, before);
        return node;
    }


    pub = {
	    /**
	     * Returns the markup for the passed Element(s) config.
	     * @param {Object} o The DOM object spec (and children)
	     * @return {String}
	     */
	    markup : function(o){
	        return createHtml(o);
	    },

	    /**
	     * Inserts an HTML fragment into the DOM.
	     * @param {String} where Where to insert the html in relation to el - beforeBegin, afterBegin, beforeEnd, afterEnd.
	     * @param {HTMLElement} el The context element
	     * @param {String} html The HTML fragmenet
	     * @return {HTMLElement} The new node
	     */
	    insertHtml : function(where, el, html){
	        var hash = {},
	        	hashVal,
 	        	setStart,
	        	range,
	        	frag,
	        	rangeEl,
	        	rs;

	        where = where.toLowerCase();
	        // add these here because they are used in both branches of the condition.
	        hash[beforebegin] = ['BeforeBegin', 'previousSibling'];
	        hash[afterend] = ['AfterEnd', 'nextSibling'];

	        if (el.insertAdjacentHTML) {
	            if(tableRe.test(el.tagName) && (rs = insertIntoTable(el.tagName.toLowerCase(), where, el, html))){
	            	return rs;
	            }
	            // add these two to the hash.
	            hash[afterbegin] = ['AfterBegin', 'firstChild'];
	            hash[beforeend] = ['BeforeEnd', 'lastChild'];
	            if ((hashVal = hash[where])) {
		        	el.insertAdjacentHTML(hashVal[0], html);
	            	return el[hashVal[1]];
	            }
	        } else {
		        range = el.ownerDocument.createRange();
		        setStart = "setStart" + (/end/i.test(where) ? "After" : "Before");
		        if (hash[where]) {
			     	range[setStart](el);
			     	frag = range.createContextualFragment(html);
			     	el.parentNode.insertBefore(frag, where == beforebegin ? el : el.nextSibling);
			     	return el[(where == beforebegin ? "previous" : "next") + "Sibling"];
		        } else {
			        rangeEl = (where == afterbegin ? "first" : "last") + "Child";
			        if (el.firstChild) {
				        range[setStart](el[rangeEl]);
				        frag = range.createContextualFragment(html);
                        if(where == afterbegin){
                            el.insertBefore(frag, el.firstChild);
                        }else{
                            el.appendChild(frag);
                        }
			        } else {
		 	            el.innerHTML = html;
	 	            }
	 	            return el[rangeEl];
		        }
	        }
	        throw 'Illegal insertion point -> "' + where + '"';
	    },

	    /**
	     * Creates new DOM element(s) and inserts them before el.
	     * @param {Mixed} el The context element
	     * @param {Object/String} o The DOM object spec (and children) or raw HTML blob
	     * @param {Boolean} returnElement (optional) true to return a Ext.Element
	     * @return {HTMLElement/Ext.Element} The new node
	     */
	    insertBefore : function(el, o, returnElement){
	        return doInsert(el, o, returnElement, beforebegin);
	    },

	    /**
	     * Creates new DOM element(s) and inserts them after el.
	     * @param {Mixed} el The context element
	     * @param {Object} o The DOM object spec (and children)
	     * @param {Boolean} returnElement (optional) true to return a Ext.Element
	     * @return {HTMLElement/Ext.Element} The new node
	     */
	    insertAfter : function(el, o, returnElement){
	        return doInsert(el, o, returnElement, afterend, "nextSibling");
	    },

	    /**
	     * Creates new DOM element(s) and inserts them as the first child of el.
	     * @param {Mixed} el The context element
	     * @param {Object/String} o The DOM object spec (and children) or raw HTML blob
	     * @param {Boolean} returnElement (optional) true to return a Ext.Element
	     * @return {HTMLElement/Ext.Element} The new node
	     */
	    insertFirst : function(el, o, returnElement){
	        return doInsert(el, o, returnElement, afterbegin, "firstChild");
	    },

	    /**
	     * Creates new DOM element(s) and appends them to el.
	     * @param {Mixed} el The context element
	     * @param {Object/String} o The DOM object spec (and children) or raw HTML blob
	     * @param {Boolean} returnElement (optional) true to return a Ext.Element
	     * @return {HTMLElement/Ext.Element} The new node
	     */
	    append : function(el, o, returnElement){
		    return doInsert(el, o, returnElement, beforeend, "", true);
	    },

	    /**
	     * Creates new DOM element(s) and overwrites the contents of el with them.
	     * @param {Mixed} el The context element
	     * @param {Object/String} o The DOM object spec (and children) or raw HTML blob
	     * @param {Boolean} returnElement (optional) true to return a Ext.Element
	     * @return {HTMLElement/Ext.Element} The new node
	     */
	    overwrite : function(el, o, returnElement){
	        el = Ext.getDom(el);
	        el.innerHTML = createHtml(o);
	        return returnElement ? Ext.get(el.firstChild) : el.firstChild;
	    },

	    createHtml : createHtml
    };
    return pub;
}();/**
 * @class Ext.DomHelper
 */
Ext.apply(Ext.DomHelper,
function(){
	var pub,
		afterbegin = 'afterbegin',
    	afterend = 'afterend',
    	beforebegin = 'beforebegin',
    	beforeend = 'beforeend';

	// private
    function doInsert(el, o, returnElement, pos, sibling, append){
        el = Ext.getDom(el);
        var newNode;
        if (pub.useDom) {
            newNode = createDom(o, null);
            if (append) {
	            el.appendChild(newNode);
            } else {
	        	(sibling == 'firstChild' ? el : el.parentNode).insertBefore(newNode, el[sibling] || el);
            }
        } else {
            newNode = Ext.DomHelper.insertHtml(pos, el, Ext.DomHelper.createHtml(o));
        }
        return returnElement ? Ext.get(newNode, true) : newNode;
    }

	// build as dom
    /** @ignore */
    function createDom(o, parentNode){
        var el,
        	doc = document,
        	useSet,
        	attr,
        	val,
        	cn;

        if (Ext.isArray(o)) {                       // Allow Arrays of siblings to be inserted
            el = doc.createDocumentFragment(); // in one shot using a DocumentFragment
	        Ext.each(o, function(v) {
                createDom(v, el);
            });
        } else if (Ext.isString(o)) {         // Allow a string as a child spec.
            el = doc.createTextNode(o);
        } else {
            el = doc.createElement( o.tag || 'div' );
            useSet = !!el.setAttribute; // In IE some elements don't have setAttribute
            Ext.iterate(o, function(attr, val){
                if(!/tag|children|cn|html|style/.test(attr)){
	                if(attr == 'cls'){
	                    el.className = val;
	                }else{
                        if(useSet){
                            el.setAttribute(attr, val);
                        }else{
                            el[attr] = val;
                        }
	                }
                }
            });
            pub.applyStyles(el, o.style);

            if ((cn = o.children || o.cn)) {
                createDom(cn, el);
            } else if (o.html) {
                el.innerHTML = o.html;
            }
        }
        if(parentNode){
           parentNode.appendChild(el);
        }
        return el;
    }

	pub = {
		/**
	     * Creates a new Ext.Template from the DOM object spec.
	     * @param {Object} o The DOM object spec (and children)
	     * @return {Ext.Template} The new template
	     */
	    createTemplate : function(o){
	        var html = Ext.DomHelper.createHtml(o);
	        return new Ext.Template(html);
	    },

		/** True to force the use of DOM instead of html fragments @type Boolean */
	    useDom : false,

	    /**
	     * Applies a style specification to an element.
	     * @param {String/HTMLElement} el The element to apply styles to
	     * @param {String/Object/Function} styles A style specification string e.g. 'width:100px', or object in the form {width:'100px'}, or
	     * a function which returns such a specification.
	     */
	    applyStyles : function(el, styles){
		    if(styles){
				var i = 0,
	    			len,
	    			style;

	    		el = Ext.fly(el);
				if(Ext.isFunction(styles)){
   					styles = styles.call();
				}
				if(Ext.isString(styles)){
					styles = styles.trim().split(/\s*(?::|;)\s*/);
					for(len = styles.length; i < len;){
						el.setStyle(styles[i++], styles[i++]);
					}
				}else if (Ext.isObject(styles)){
					el.setStyle(styles);
				}
			}
	    },

	    /**
	     * Creates new DOM element(s) and inserts them before el.
	     * @param {Mixed} el The context element
	     * @param {Object/String} o The DOM object spec (and children) or raw HTML blob
	     * @param {Boolean} returnElement (optional) true to return a Ext.Element
	     * @return {HTMLElement/Ext.Element} The new node
         * @hide (repeat)
	     */
	    insertBefore : function(el, o, returnElement){
	        return doInsert(el, o, returnElement, beforebegin);
	    },

	    /**
	     * Creates new DOM element(s) and inserts them after el.
	     * @param {Mixed} el The context element
	     * @param {Object} o The DOM object spec (and children)
	     * @param {Boolean} returnElement (optional) true to return a Ext.Element
	     * @return {HTMLElement/Ext.Element} The new node
         * @hide (repeat)
	     */
	    insertAfter : function(el, o, returnElement){
	        return doInsert(el, o, returnElement, afterend, 'nextSibling');
	    },

	    /**
	     * Creates new DOM element(s) and inserts them as the first child of el.
	     * @param {Mixed} el The context element
	     * @param {Object/String} o The DOM object spec (and children) or raw HTML blob
	     * @param {Boolean} returnElement (optional) true to return a Ext.Element
	     * @return {HTMLElement/Ext.Element} The new node
         * @hide (repeat)
	     */
	    insertFirst : function(el, o, returnElement){
	        return doInsert(el, o, returnElement, afterbegin, 'firstChild');
	    },

	    /**
	     * Creates new DOM element(s) and appends them to el.
	     * @param {Mixed} el The context element
	     * @param {Object/String} o The DOM object spec (and children) or raw HTML blob
	     * @param {Boolean} returnElement (optional) true to return a Ext.Element
	     * @return {HTMLElement/Ext.Element} The new node
         * @hide (repeat)
	     */
	    append: function(el, o, returnElement){
            return doInsert(el, o, returnElement, beforeend, '', true);
        },

	    /**
	     * Creates new DOM element(s) without inserting them to the document.
	     * @param {Object/String} o The DOM object spec (and children) or raw HTML blob
	     * @return {HTMLElement} The new uninserted node
	     */
        createDom: createDom
	};
	return pub;
}());/**
 * @class Ext.Template
 * Represents an HTML fragment template. Templates can be precompiled for greater performance.
 * For a list of available format functions, see {@link Ext.util.Format}.<br />
 * Usage:
<pre><code>
var t = new Ext.Template(
    '&lt;div name="{id}"&gt;',
        '&lt;span class="{cls}"&gt;{name:trim} {value:ellipsis(10)}&lt;/span&gt;',
    '&lt;/div&gt;'
);
t.append('some-element', {id: 'myid', cls: 'myclass', name: 'foo', value: 'bar'});
</code></pre>
 * @constructor
 * @param {String/Array} html The HTML fragment or an array of fragments to join("") or multiple arguments to join("")
 */
Ext.Template = function(html){
    var me = this,
    	a = arguments,
    	buf = [];

    if (Ext.isArray(html)) {
        html = html.join("");
    } else if (a.length > 1) {
	    Ext.each(a, function(v) {
            if (Ext.isObject(v)) {
                Ext.apply(me, v);
            } else {
                buf.push(v);
            }
        });
        html = buf.join('');
    }

    /**@private*/
    me.html = html;
    if (me.compiled) {
        me.compile();
    }
};
Ext.Template.prototype = {
    /**
     * Returns an HTML fragment of this template with the specified values applied.
     * @param {Object/Array} values The template values. Can be an array if your params are numeric (i.e. {0}) or an object (i.e. {foo: 'bar'})
     * @return {String} The HTML fragment
     */
    applyTemplate : function(values){
		var me = this;

        return me.compiled ?
        		me.compiled(values) :
				me.html.replace(me.re, function(m, name){
		        	return values[name] !== undefined ? values[name] : "";
		        });
	},

    /**
     * Sets the HTML used as the template and optionally compiles it.
     * @param {String} html
     * @param {Boolean} compile (optional) True to compile the template (defaults to undefined)
     * @return {Ext.Template} this
     */
    set : function(html, compile){
	    var me = this;
        me.html = html;
        me.compiled = null;
        return compile ? me.compile() : me;
    },

    /**
    * The regular expression used to match template variables
    * @type RegExp
    * @property
    */
    re : /\{([\w-]+)\}/g,

    /**
     * Compiles the template into an internal function, eliminating the RegEx overhead.
     * @return {Ext.Template} this
     */
    compile : function(){
        var me = this,
        	sep = Ext.isGecko ? "+" : ",";

        function fn(m, name){                        
	        name = "values['" + name + "']";
	        return "'"+ sep + '(' + name + " == undefined ? '' : " + name + ')' + sep + "'";
        }
                
        eval("this.compiled = function(values){ return " + (Ext.isGecko ? "'" : "['") +
             me.html.replace(/\\/g, '\\\\').replace(/(\r\n|\n)/g, '\\n').replace(/'/g, "\\'").replace(this.re, fn) +
             (Ext.isGecko ?  "';};" : "'].join('');};"));
        return me;
    },

    /**
     * Applies the supplied values to the template and inserts the new node(s) as the first child of el.
     * @param {Mixed} el The context element
     * @param {Object/Array} values The template values. Can be an array if your params are numeric (i.e. {0}) or an object (i.e. {foo: 'bar'})
     * @param {Boolean} returnElement (optional) true to return a Ext.Element (defaults to undefined)
     * @return {HTMLElement/Ext.Element} The new node or Element
     */
    insertFirst: function(el, values, returnElement){
        return this.doInsert('afterBegin', el, values, returnElement);
    },

    /**
     * Applies the supplied values to the template and inserts the new node(s) before el.
     * @param {Mixed} el The context element
     * @param {Object/Array} values The template values. Can be an array if your params are numeric (i.e. {0}) or an object (i.e. {foo: 'bar'})
     * @param {Boolean} returnElement (optional) true to return a Ext.Element (defaults to undefined)
     * @return {HTMLElement/Ext.Element} The new node or Element
     */
    insertBefore: function(el, values, returnElement){
        return this.doInsert('beforeBegin', el, values, returnElement);
    },

    /**
     * Applies the supplied values to the template and inserts the new node(s) after el.
     * @param {Mixed} el The context element
     * @param {Object/Array} values The template values. Can be an array if your params are numeric (i.e. {0}) or an object (i.e. {foo: 'bar'})
     * @param {Boolean} returnElement (optional) true to return a Ext.Element (defaults to undefined)
     * @return {HTMLElement/Ext.Element} The new node or Element
     */
    insertAfter : function(el, values, returnElement){
        return this.doInsert('afterEnd', el, values, returnElement);
    },

    /**
     * Applies the supplied values to the template and appends the new node(s) to el.
     * @param {Mixed} el The context element
     * @param {Object/Array} values The template values. Can be an array if your params are numeric (i.e. {0}) or an object (i.e. {foo: 'bar'})
     * @param {Boolean} returnElement (optional) true to return a Ext.Element (defaults to undefined)
     * @return {HTMLElement/Ext.Element} The new node or Element
     */
    append : function(el, values, returnElement){
        return this.doInsert('beforeEnd', el, values, returnElement);
    },

    doInsert : function(where, el, values, returnEl){
        el = Ext.getDom(el);
        var newNode = Ext.DomHelper.insertHtml(where, el, this.applyTemplate(values));
        return returnEl ? Ext.get(newNode, true) : newNode;
    },

    /**
     * Applies the supplied values to the template and overwrites the content of el with the new node(s).
     * @param {Mixed} el The context element
     * @param {Object/Array} values The template values. Can be an array if your params are numeric (i.e. {0}) or an object (i.e. {foo: 'bar'})
     * @param {Boolean} returnElement (optional) true to return a Ext.Element (defaults to undefined)
     * @return {HTMLElement/Ext.Element} The new node or Element
     */
    overwrite : function(el, values, returnElement){
        el = Ext.getDom(el);
        el.innerHTML = this.applyTemplate(values);
        return returnElement ? Ext.get(el.firstChild, true) : el.firstChild;
    }
};
/**
 * Alias for {@link #applyTemplate}
 * Returns an HTML fragment of this template with the specified values applied.
 * @param {Object/Array} values The template values. Can be an array if your params are numeric (i.e. {0}) or an object (i.e. {foo: 'bar'})
 * @return {String} The HTML fragment
 * @member Ext.Template
 * @method apply
 */
Ext.Template.prototype.apply = Ext.Template.prototype.applyTemplate;

/**
 * Creates a template from the passed element's value (<i>display:none</i> textarea, preferred) or innerHTML.
 * @param {String/HTMLElement} el A DOM element or its id
 * @param {Object} config A configuration object
 * @return {Ext.Template} The created template
 * @static
 */
Ext.Template.from = function(el, config){
    el = Ext.getDom(el);
    return new Ext.Template(el.value || el.innerHTML, config || '');
};/**
 * @class Ext.Template
 */
Ext.apply(Ext.Template.prototype, {
    /**
     * Returns an HTML fragment of this template with the specified values applied.
     * @param {Object/Array} values The template values. Can be an array if your params are numeric (i.e. {0}) or an object (i.e. {foo: 'bar'})
     * @return {String} The HTML fragment
     * @hide repeat doc
     */
    applyTemplate : function(values){
		var me = this,
			useF = me.disableFormats !== true,
        	fm = Ext.util.Format, 
        	tpl = me;	    
	    
        if(me.compiled){
            return me.compiled(values);
        }
        function fn(m, name, format, args){
            if (format && useF) {
                if (format.substr(0, 5) == "this.") {
                    return tpl.call(format.substr(5), values[name], values);
                } else {
                    if (args) {
                        // quoted values are required for strings in compiled templates,
                        // but for non compiled we need to strip them
                        // quoted reversed for jsmin
                        var re = /^\s*['"](.*)["']\s*$/;
                        args = args.split(',');
                        for(var i = 0, len = args.length; i < len; i++){
                            args[i] = args[i].replace(re, "$1");
                        }
                        args = [values[name]].concat(args);
                    } else {
                        args = [values[name]];
                    }
                    return fm[format].apply(fm, args);
                }
            } else {
                return values[name] !== undefined ? values[name] : "";
            }
        }
        return me.html.replace(me.re, fn);
    },
		
    /**
     * <tt>true</tt> to disable format functions (defaults to <tt>false</tt>)
     * @type Boolean
     * @property
     */
    disableFormats : false,				
	
    /**
     * The regular expression used to match template variables
     * @type RegExp
     * @property
     * @hide repeat doc
     */
    re : /\{([\w-]+)(?:\:([\w\.]*)(?:\((.*?)?\))?)?\}/g,
    
    /**
     * Compiles the template into an internal function, eliminating the RegEx overhead.
     * @return {Ext.Template} this
     * @hide repeat doc
     */
    compile : function(){
        var me = this,
        	fm = Ext.util.Format,
        	useF = me.disableFormats !== true,
        	sep = Ext.isGecko ? "+" : ",",
        	body;
        
        function fn(m, name, format, args){
            if(format && useF){
                args = args ? ',' + args : "";
                if(format.substr(0, 5) != "this."){
                    format = "fm." + format + '(';
                }else{
                    format = 'this.call("'+ format.substr(5) + '", ';
                    args = ", values";
                }
            }else{
                args= ''; format = "(values['" + name + "'] == undefined ? '' : ";
            }
            return "'"+ sep + format + "values['" + name + "']" + args + ")"+sep+"'";
        }
        
        // branched to use + in gecko and [].join() in others
        if(Ext.isGecko){
            body = "this.compiled = function(values){ return '" +
                   me.html.replace(/\\/g, '\\\\').replace(/(\r\n|\n)/g, '\\n').replace(/'/g, "\\'").replace(this.re, fn) +
                    "';};";
        }else{
            body = ["this.compiled = function(values){ return ['"];
            body.push(me.html.replace(/\\/g, '\\\\').replace(/(\r\n|\n)/g, '\\n').replace(/'/g, "\\'").replace(this.re, fn));
            body.push("'].join('');};");
            body = body.join('');
        }
        eval(body);
        return me;
    },
    
    // private function used to call members
    call : function(fnName, value, allValues){
        return this[fnName](value, allValues);
    }
});
Ext.Template.prototype.apply = Ext.Template.prototype.applyTemplate; /*
 * This is code is also distributed under MIT license for use
 * with jQuery and prototype JavaScript libraries.
 */
/**
 * @class Ext.DomQuery
Provides high performance selector/xpath processing by compiling queries into reusable functions. New pseudo classes and matchers can be plugged. It works on HTML and XML documents (if a content node is passed in).
<p>
DomQuery supports most of the <a href="http://www.w3.org/TR/2005/WD-css3-selectors-20051215/#selectors">CSS3 selectors spec</a>, along with some custom selectors and basic XPath.</p>

<p>
All selectors, attribute filters and pseudos below can be combined infinitely in any order. For example "div.foo:nth-child(odd)[@foo=bar].bar:first" would be a perfectly valid selector. Node filters are processed in the order in which they appear, which allows you to optimize your queries for your document structure.
</p>
<h4>Element Selectors:</h4>
<ul class="list">
    <li> <b>*</b> any element</li>
    <li> <b>E</b> an element with the tag E</li>
    <li> <b>E F</b> All descendent elements of E that have the tag F</li>
    <li> <b>E > F</b> or <b>E/F</b> all direct 