<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no,minimal-ui">
<h2>Please Select a SSID</h2>

<table width="100%" border="1" cellspacing="0" cellpadding="0" style="text-align:center">
  <tr>
    <td>ssid</td>
    <td>authmode</td>
    <td>rssi</td>
    <td>select</td>
  </tr>
  <tr>
    <td>_bobo</td>
    <td>1</td>
    <td>-2</td>
    <td><input name="select" type="button" value="select"  onClick="fill_ssid(this)" /></td>
  </tr>
  <tr>
    <td>_aann</td>
    <td>1</td>
    <td>-2</td>
    <td><input name="select" type="button" value="select"  onClick="fill_ssid(this)" /></td>
  </tr>
  
  
  
</table>

<form action="" method="get">
  <table>
    <tr>
      <td>SSID：</td>
      <td><input name="ssid" type="text" id="ssid" /></td>
    </tr>
    <tr>
      <td>PASSWORD：</td>
      <td><input name="password" type="password" id="password"/></td>
    </tr>
    <tr>
      <td><input name="OK" type="submit" value="Ok" onclick="return check_form()" /></td>
    </tr>
  </table>
</form>

<script language="javascript">
function fill_ssid(node)
{
	var tr1 = node.parentNode.parentNode;  
    document.getElementById("ssid").value=tr1.cells[0].innerText;
	document.getElementById("password").focus();  		
}
function check_form()
{
	if(document.getElementById("ssid").value=="")
	{
		alert("please select or input a ssid!")
		return false;
	}
	if(document.getElementById("password").value=="")
	{
		if(confirm("empty password?") == false)
			return false;
		else
			return true;
	}
	return true;	
}
</script>