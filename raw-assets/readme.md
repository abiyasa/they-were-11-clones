# Raw Assets
This is readme how to use the raw assets before you can use it in the game.

## 3D Models
Models are done using Metasequoia (http://www.metaseq.net/).
You can use Metaseq Freeware edition to create and edit MQO file,
but you need to buy the license in order to convert them into OBJ (and able to use Metaseq plugins which are
very handy to have). It's not that expensive, only $45 ;-)

### Converting Metaseq model (MQO) to OBJ
Away3D 4 cannot load MQO, therefore it has to be converted to OBJ. These are the settings:
	
*  Size, Multiply: **x1**
*  Axis: **Direct3D**
*  Obj Option
	*  Visible object only: **false**
	*  Grouping: **false**
	*  Normal vector: **true**
	*  UV Mapping: **true**, with invert V: **true**
	*  Material Library: **false**
	*  Freeze Patches: **true**
*  Return code: **Unix(LF)**

## Texture Atlas
All buttons & logos are packed into 1 spritesheet using Paint.NET (see pdn file)
