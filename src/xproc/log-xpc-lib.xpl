<p:library  xmlns:p="http://www.w3.org/ns/xproc" 
 xmlns:xs="http://www.w3.org/2001/XMLSchema" 
 xmlns:xlog="https://www.daliboris.cz/ns/xproc/logging/1.0"
 xmlns:xhtml="http://www.w3.org/1999/xhtml"
 xmlns:c="http://www.w3.org/ns/xproc-step"
 version="3.0">
 
 <p:documentation>
  <xhtml:section>
   <xhtml:h1></xhtml:h1>
   <xhtml:p></xhtml:p>
  </xhtml:section>
 </p:documentation>
 
 <p:declare-step type="xlog:log" name="logging" visibility="public">
  <p:documentation>
   <xhtml:section>
    <xhtml:h2></xhtml:h2>
    <xhtml:p></xhtml:p>    
   </xhtml:section>
  </p:documentation>
  
  <p:option name="debug" as="xs:boolean" required="true" />
  <p:option name="message" as="xs:string" required="true" />
  <p:option name="format" as="xs:string" values="('xml', 'text', 'json')" select="'xml'" />
  <p:option name="level" as="xs:string" values="('trace', 'debug', 'info', 'warn', 'error', 'fatal')" select="'info'" />
  
  <p:input  port="source" primary="true"/>
  <p:input  port="log" primary="false" sequence="true"/>
  <p:output port="result" primary="true" pipe="source@logging" />
  
  <p:if test="$debug">
   <p:choose>
    <p:when test="$format = 'xml'">
     <p:identity>
      <p:with-input port="source">
       <xlog:log time="{current-dateTime()}" level="{$level}">{$message}</xlog:log>
      </p:with-input>
     </p:identity>
    </p:when>
    <p:when test="$format = 'text'">
     <p:identity>
      <p:with-input port="source">
       <p:inline content-type="text/plain">[{current-dateTime()}] {$level}: {$message}</p:inline>
      </p:with-input>
     </p:identity>
    </p:when>
   </p:choose>
   
   <p:if test="($format = 'text')">
    <p:identity message="{/}" />
   </p:if>

  </p:if>
  
 </p:declare-step>
 
 <p:declare-step type="xlog:log-message" name="logging-message" visibility="public">
  <p:documentation>
   <xhtml:section>
    <xhtml:h2></xhtml:h2>
    <xhtml:p></xhtml:p>    
   </xhtml:section>
  </p:documentation>
  
  <p:option name="debug" as="xs:boolean" required="true" />
  <p:option name="message" as="xs:string" required="true" />
  <p:option name="format" as="xs:string" values="('xml', 'text', 'json')" select="'xml'" />
  <p:option name="level" as="xs:string" values="('trace', 'debug', 'info', 'warn', 'error', 'fatal')" select="'info'" />
  
  <p:input  port="source" primary="true"/>
  <p:output port="result" primary="true" pipe="source@logging-message" />
  
  <p:if test="$debug">
   <p:choose>
    <p:when test="$format = 'xml'">
     <p:identity>
      <p:with-input port="source">
       <xlog:log time="{current-dateTime()}" level="{$level}">{$message}</xlog:log>
      </p:with-input>
     </p:identity>
    </p:when>
    <p:when test="$format = 'text'">
     <p:identity>
      <p:with-input port="source">
       <p:inline content-type="text/plain">[{current-dateTime()}] {$level}: {$message}</p:inline>
      </p:with-input>
     </p:identity>
    </p:when>
   </p:choose>
   
   <p:if test="($format = 'text')">
    <p:identity message="{/}" />
   </p:if>
   
  </p:if>
  
 </p:declare-step>
 
 
 <p:declare-step type="xlog:store" name="storing" visibility="public">
  <p:documentation>
   <xhtml:section>
    <xhtml:h2></xhtml:h2>
    <xhtml:p></xhtml:p>    
   </xhtml:section>
  </p:documentation>
  
  <!-- INPUT PORTS -->
  <p:input  port="source" primary="true"/>

  <!-- OUTPUT PORTS -->
  <p:output port="result" primary="true" pipe="source@storing" />
  <p:output port="report" primary="false"  pipe="result@report"/>
  
  <!-- OPTIONS -->
  <p:option name="base-uri" as="xs:anyURI" select="static-base-uri()"/>
  <p:option name="debug" as="xs:boolean" required="true" />
  
  <p:option name="output-directory" as="xs:string" required="true" />
  <p:option name="file-name" as="xs:string" required="true" />
  <p:option name="step" as="xs:integer?" />
  
 
  <!-- VARIABLES -->
  <p:variable name="content-type" select="p:document-property(/, 'Q{}' || 'content-type')" />
  <p:variable name="prefix" select="if(exists($step)) then format-integer($step, '0000') || '-' else ''" />
  <p:variable name="full-path" select="concat($output-directory, '/', $prefix, $file-name)" />
  
  <p:variable name="full-path-uri"  select="resolve-uri($full-path, $base-uri)" />
  
  <p:if test="$debug">
   <p:store href="{$full-path-uri}"  message="Storing {$content-type} to {$full-path-uri}" serialization="map{'indent' : true()}" />
  </p:if>

  <p:identity>
   <p:with-input port="source">
    <c:result />
   </p:with-input>
  </p:identity>
  <p:if test="$debug">
   <p:identity>
    <p:with-input port="source">
     <c:result>{$full-path-uri}</c:result>
    </p:with-input>
   </p:identity>
  </p:if>
  <p:namespace-delete prefixes="xlog xs xhtml" />
  <p:identity name="report" />
  
 </p:declare-step>
 
</p:library>