<p:declare-step 
	xmlns:p="http://www.w3.org/ns/xproc" 
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:xlog="https://www.daliboris.cz/ns/xproc/logging/1.0"
	xmlns:xhtml="http://www.w3.org/1999/xhtml"
	version="3.0">
	
	<p:import href="../../xproc/log-xpc-lib.xpl" />
	
	<p:documentation>
		<xhtml:section>
			<xhtml:h2></xhtml:h2>
			<xhtml:p></xhtml:p>
		</xhtml:section>
	</p:documentation>
   
  <p:input port="source" primary="true">
  	<p:inline>
  		<document />
  	</p:inline>
  </p:input>
   
	<p:output port="result" primary="true" />
	
	<p:option name="debug-path" select="()" as="xs:string?" />
	
	<xlog:store debug="false" output-directory="../tests/output" file-name="report-test.xml" name="storing" />
		
	<p:identity>
		<p:with-input pipe="report@storing" />
	</p:identity>
	

</p:declare-step>
