varying vec4 v_fragmentColor;
varying vec2 v_texCoord;
uniform float outlineSize;
uniform vec3 outlineColor;
uniform vec2 textureSize;
uniform vec3 foregroundColor;

const float cosArray[12] = {1, 0.866, 0.5, 0, -0.5, -0.866, -0.1, -0.866, -0.5, 0, 0.5, 0.866};
const float sinArray[12] = {0, 0.5, 0.866, 1, 0.866, 0.5, 0, -0.5, -0.866, -1, -0.866, -0.5};

int getIsStrokeWithAngelIndex(int index)
{
	int stroke = 0;
	float a = texture2D(CC_Texture0, vec2(v_texCoord.x + outlineSize * cosArray[index] / textureSize.x, v_texCoord.y + outlineSize * sinArray[index] / textureSize.y)).a;
	if (a >= 0.5)
	{
		stroke = 1;
	}

	return stroke;
}

void main()
{
	vec4 myC = texture2D(CC_Texture0, vec2(v_texCoord.x, v_texCoord.y));
	myC.rgb *= foregroundColor;
	if (myC.a >= 0.5)
	{
		gl_FragColor = v_fragmentColor * myC;
		return;
	}

	int strokeCount = 0;
	strokeCount += getIsStrokeWithAngelIndex(0);
	strokeCount += getIsStrokeWithAngelIndex(1);
	strokeCount += getIsStrokeWithAngelIndex(2);
	strokeCount += getIsStrokeWithAngelIndex(3);
	strokeCount += getIsStrokeWithAngelIndex(4);
	strokeCount += getIsStrokeWithAngelIndex(5);
	strokeCount += getIsStrokeWithAngelIndex(6);
	strokeCount += getIsStrokeWithAngelIndex(7);
	strokeCount += getIsStrokeWithAngelIndex(8);
	strokeCount += getIsStrokeWithAngelIndex(9);
	strokeCount += getIsStrokeWithAngelIndex(10);
	strokeCount += getIsStrokeWithAngelIndex(11);

	bool stroke = false;
	if (strokeCount > 0)
	{
		stroke = true;
	}

	if (stroke)
	{
		myC.rgb = outlineColor;
		myC.a = 1.0;
	}

	gl_FragColor = v_fragmentColor * myC;
}