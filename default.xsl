<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fn="http://www.w3.org/2005/02/xpath-functions">

<xsl:template match="/modules">
<html>
<body>
  <xsl:for-each select="module">
    <h1>
      <xsl:attribute name="id">
        <xsl:value-of select="id" />
      </xsl:attribute>
      <a>
        <xsl:attribute name="href">
          #<xsl:value-of select="id" />
        </xsl:attribute>
        <xsl:value-of select="name" />
      </a>
    </h1>
    <xsl:for-each select="functions/function">
      <h2>
        <xsl:attribute name="id">
          <xsl:value-of select="id" />
        </xsl:attribute>
        <a>
          <xsl:attribute name="href">
            #<xsl:value-of select="id" />
          </xsl:attribute>
          <xsl:value-of select="summary/code" /> - <xsl:value-of select="summary/name" />
        </a>
      </h2>
      <h3>
        <xsl:attribute name="id">
          <xsl:value-of select="id" />-summary</xsl:attribute>
        <a>
          <xsl:attribute name="href">
            #<xsl:value-of select="id" />-summary</xsl:attribute>
          功能概述
        </a>
      </h3>

      <xsl:apply-templates select="summary" />

      <h3>
        <xsl:attribute name="id">
          <xsl:value-of select="id" />-api</xsl:attribute>
        <a>
          <xsl:attribute name="href">
            #<xsl:value-of select="id" />-api</xsl:attribute>
          API
        </a>
      </h3>

      <xsl:apply-templates select="api" />

    </xsl:for-each>
</xsl:for-each>
</body>
</html>
</xsl:template>

<xsl:template match="summary">
<table class="summary" border="1">
  <xsl:attribute name="id">
    <xsl:value-of select="../id" />-summary-table
  </xsl:attribute>
  <tr>
    <td class="key">功能编号</td><td><xsl:value-of select="code" /></td>
    <td class="key">功能名称</td><td><xsl:value-of select="name" /></td>
  </tr>
  <tr>
    <td class="key">用途</td>
    <td class="width-3" colspan="3"><xsl:value-of select="usage" /></td>
  </tr>
  <tr>
    <td class="key">操作</td>
    <td class="width-3" colspan="3"><xsl:value-of select="operation" /></td>
  </tr>
  <tr>
    <td class="key">备注</td>
    <td class="width-3" colspan="3"><xsl:value-of select="note" /></td>
  </tr>
</table>
</xsl:template>

<xsl:template match="api">
<table class="api" border="1">
  <xsl:attribute name="id">
    <xsl:value-of select="../id" />-api-table
  </xsl:attribute>

  <tr>
    <td class="key">API名称</td>
    <td class="width-4 name" colspan="4">
      <xsl:value-of select="name" />
    </td>
  </tr>

  <tr>
    <td class="key">HTTP方法</td>
    <td class="width-4 method" colspan="4">
      <xsl:value-of select="method" />
    </td>
  </tr>

  <tr>
    <td class="key">URL</td>
    <td class="width-4 url" colspan="4">
      <xsl:value-of select="url" />
    </td>
  </tr>

  <xsl:if test="header">
    <tr>
      <td class="key">HTTP请求头</td>
      <td class="width-4 httphead" colspan="4">
        <pre><code class="language-http">
          <xsl:value-of select="httphead" />
        </code></pre></td>
    </tr>
  </xsl:if>

  <tr>
    <td class="key">
      <xsl:attribute name="rowspan">
        <xsl:value-of select="count(params/param)+1" />
      </xsl:attribute>
      参数</td>
    <td class="key">参数名称</td>
    <td class="key">是否可选</td>
    <td class="key">说明</td>
    <td class="key">输入
      <input type="button" onclick="testapi(this)" value="测试" />
    </td>
  </tr>
  <xsl:for-each select="params/param">
    <tr class="param">
      <td class="pkey"><xsl:value-of select="key"/></td>
      <td class="optional"><xsl:value-of select="optional"/></td>
      <td><xsl:value-of select="description"/></td>
      <td>
        <input>
          <xsl:attribute name="name">
            <xsl:value-of select="key" />
          </xsl:attribute>
          <xsl:attribute name="placeholder">
            <xsl:value-of select="example"/>
          </xsl:attribute>
        </input>
      </td>
    </tr>
  </xsl:for-each>

  <xsl:for-each select="response">
    <tr class="response">
      <td rowspan="3" class="key">
        <xsl:attribute name="rowspan">
          <xsl:value-of select="boolean(headers/header)+2" />
        </xsl:attribute>
        响应示例<br />（<xsl:value-of select="description" />）</td>
      <td class="key">HTTP响应状态码</td><td class="width-3" colspan="3">
        <pre><code class="language-http">
          <xsl:value-of select="httpcode" />
        </code></pre>
      </td>
    </tr>

    <xsl:if test="headers/header">
      <tr>
        <td class="key">HTTP响应头</td>
        <td class="width-3" colspan="3">
          <pre><code class="language-http">
            <xsl:for-each select="headers/header">
              <xsl:value-of select="key" />: <xsl:value-of select="value" />
            </xsl:for-each>
          </code></pre>
        </td>
      </tr>
    </xsl:if>

    <tr><td class="key">HTTP响应体</td><td class="width-3" colspan="3">
      <pre><code>
        <xsl:attribute name="class">
          <xsl:value-of select="concat('language-',string(httpbody/@type))" />
        </xsl:attribute>
        <xsl:value-of select="httpbody" />
      </code></pre>
    </td></tr>
  </xsl:for-each>

  <xsl:if test="note">
    <tr><td class="key">备注</td><td class="width-4" colspan="4">
      <xsl:value-of select="note" />
    </td></tr>
  </xsl:if>

</table>
</xsl:template>
