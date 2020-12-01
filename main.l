%option noyywrap
%{
    #include"common.h"
    #include"main.tab.hh"
    #include<math.h>
    int otoi(string s)
    {
        int ans = 0, power = 0;
        for(int i=s.length()-1;i>=0;i--)
        {
            ans += int(s[i]-'0')*pow(8, power);
            power++;
        }
        return ans;
    }
    int htoi(string s)
    {
        int ans = 0, power = 0;
        for(int i=s.length()-1;i>1;i--)
        {
            int temp;
            if('0'<=s[i]&&s[i]<='9')
            {
                temp = s[i] - '0';
            }
            if('a'<=s[i]&&s[i]<='f')
            {
                temp = s[i] - 'a' + 10;
            }
            if('A'<=s[i]&&s[i]<='F')
            {
                temp = s[i] - 'A' + 10;
            }
            ans += temp*pow(16, power);
            power++;
        }
        return ans;
    }
%}

INTEGER (+|-)?0|[1-9][0-9]*
OCT 00|0[1-7][0-7]*
INT16 0x0|0x[1-9a-fA-F][0-9a-fA-F]*
CHARACTER \'(.*)\'
STRING \"(.*)\"
ID [[:alpha:]_][[:alpha:][:digit:]_]*
REF \&[[:alpha:]_][[:alpha:][:digit:]_]*
PTR \*[[:alpha:]_][[:alpha:][:digit:]_]*

EOL (\r\n|\n)
WHITE [\t ]

COMMENT_BEGIN	"/*"
COMMENT_ELEMENT	.|\n
COMMENT_END	"*/"
SINGLE_COMMENT_BEGAIN "//"
SINGLE_COMMENT_ELEMENT	.
SINGLE_COMMENT_BEGAIN "\n"
%x LONGCOMMENT
%x SHORTCOMMENT
%%

"true" {
    TreeNode *node = new TreeNode(NODE_BOOL);
    node->bool_val = true;
    yylval = node;
    return TRUE;
}
"false" {
    TreeNode *node = new TreeNode(NODE_BOOL);
    node->bool_val = false;
    yylval = node;
    return FALSE;
}

"int" return INT;
"void" return VOID;
"char" return CHAR;
"string" return STRING;

"if" return IF;
"for" return FOR;
"while" return WHILE;
"else" return ELSE;
"struct" return STRUCT;

"printf" return PRINTF;
"scanf" return SCANF;
"const" return CONST;

"." return dot;
"=" return ASSIGN;

"+=" return ADDAS;
"-=" return MINAS;
"*=" return MULAS;
"/=" return DIVAS;
"%=" return MODAS;

"++" return DADD;
"--" return DMIN;
"+" return ADD;
"-" return MINUS;
"*" return MUL;
"/" return DIV;
"%" return MOD;

"&&" return AND;
"||" return OR;
"==" return EQ;
"!=" return NE;
">" return GT;
">=" return GE;
"<" return LT;
"<=" return LS;
"!" return NOT;
"," return COMMA;
";" return SEMICOLON;
"(" return LPAREN;
")" return RPAREN;
"[" return LBRACK;
"]" return RBRACK;
"{" {
    layers.push_back(layer(curlayer, lid++));
    return LBRACE;
}
"}" return RBRACE;

{INTEGER} {
    TreeNode *node = new TreeNode(NODE_CONST);
    node->int_val = atoi(yytext);
    yylval = node;
    return INTEGER;
}
{OCT} {
    TreeNode *node = new TreeNode(NODE_CONINT);
    node->int_val = otoi(yytext);
    yylval = node;
    return INTEGER;
}
{HEX} {
    TreeNode *node = new TreeNode(NODE_CONINT);
    node->int_val = htoi(yytext);
    yylval = node;
    return INTEGER;
}
{CHARACTER} {
    TreeNode *node = new TreeNode(NODE_CONCHAR);
    node->int_val = int(string(yytext)[1]);
    yylval = node;
    return CHARACTER;
}
{STRING} {
    TreeNode *node = new TreeNode(NODE_CONSTR);
    string str = string(yytext);
    str.erase(0,str.find_first_not_of("\""));
    str.erase(str.find_last_not_of("\"") + 1);
    node->str_val = str;
    yylval = node;
    return STRING;
}
{ID} {
    TreeNode *node = new TreeNode(NODE_VAR);
    node->var_name = string(yytext);
    yylval = node;
    return ID;
}
{REF} {
    TreeNode *node = new TreeNode(NODE_VAR);
    string str = string(yytext);
    str.erase(str.begin());
    node->varName = str;
    node->varFlag = VAR_REERENCE;
    yylval = node;
    return ID;
}
{PTR} {
    TreeNode *node = new TreeNode(NODE_VAR);
    string str = string(yytext);
    str.erase(str.begin());
    node->varName = str;
    node->varFlag = VAR_POINTER;
    yylval = node;
    return ID;
}
{EOL}
{WHITE}
{COMMENT_BEGIN} { BEGIN LONGCOMMENT; printf("COMMENT BEGIN\t"); }
<LONGCOMMENT>{COMMENT_ELEMENT} { printf("%s", yytext)}
<LONGCOMMENT>{COMMENT_END} { printf("COMMENT END\n"); BEGIN INITIAL; }

{SINGLE_COMMENT_BEGAIN} { BEGIN SHORTCOMMENT; printf("COMMENT:"); }
<SHORTCOMMENT>{SINGLE_COMMENT_ELEMENT} { printf("%s", yytext); }
<SHORTCOMMENT>{SINGLE_COMMENT_END} { printf("\n"); BEGIN INITIAL; }
%%