%{
    #include"common.h"
    extern TreeNode * root;
    int yylex();
    int yyerror( char const * );
    extern vector<scope> scopes;
    extern vector<variable> curscope;
    extern vector<variable> strscope;
    extern int sindex;
    extern vector<struct_def> strdef;
    extern int cur_sindex;
    extern string str_name[];
    extern int name_num;  
%}
%defines

%start program

%token ID IDadd IDptr INTEGER CHARACTER STRING
%token IF ELSE WHILE FOR STRUCT
%token CONST
%token INT VOID CHAR 
%token LPAREN RPAREN LBRACK RBRACK LBRACE RBRACE COMMA SEMICOLON
%token TRUE FALSE
%token ADD MINUS MULTI DIV MOD DADD DMIN NEG
%token ASSIGN ADDTO MINTO MULTO DIVTO MODTO
%token EQ NE BT BE LT LE NOT AND OR
%token PRINTF SCANF
%token dot

%right NEG
%right OR
%right AND
%left EQ NE BT BE LT LE
%left ADD MINUS
%left MULTI DIV MOD
%right NOT
%right DADD DMIN 
%right ASSIGN ADDTO MINTO MULTO DIVTO MODTO
%nonassoc LOWER_THEN_ELSE
%nonassoc ELSE 
%%
program
    : statements {
        root=new TreeNode(NODE_PROG);
        root->addChild($1);
        printf("\n");
        while(!curscope.empty()){
            printf("scope %d\t", sindex);
            variable tmpv = curscope[curscope.size()-1];
            switch(tmpv.type){
            case 1:
                printf("%d\tint\t%s\n", tmpv.index, tmpv.name.c_str());
                break;
            case 2:
                printf("%d\tchar %s\n", tmpv.index, tmpv.name.c_str());
                break;
            case 3:
                printf("%d\tstring\t%s\n", tmpv.index, tmpv.name.c_str());
                break;
            default:
                printf("%d\t%s\t%s\n", tmpv.index, tmpv.str_name.c_str(), tmpv.name.c_str());
                break;
            }
            curscope.pop_back();
        }
        for(int i=scopes.size();i>0;i--){
            scopes.pop_back();
        }
    }
    ;
statements
    : statement {$$=$1;}
    | statements statement{$$=$1;$$->addSibling($2);}
    ;
statement
    : instruction {$$=$1;}
    | if_else {$$=$1;}
    | while {$$=$1;}
    | for {$$=$1;}
    | LBRACE statements RBRACE {$$=$2;}
    | def_func {$$=$1;}
    | printf SEMICOLON {$$=$1;}
    | scanf SEMICOLON {$$=$1;}
    | struct_def {$$=$1;}
    ;

operation
    : IDS ASSIGN expr{
        TreeNode* node=new TreeNode(NODE_ASSIGN);
        node->addChild($1);
        node->addChild($3);
        $$=node;
    }
    | IDS ADDTO expr{
        TreeNode* node=new TreeNode(NODE_ASSIGN);
        node->opType=OP_ADD;
        node->addChild($1);
        node->addChild($3);
        $$=node;
    }
    | IDS MINTO expr{
        TreeNode* node=new TreeNode(NODE_ASSIGN);
        node->opType=OP_MINUS;
        node->addChild($1);
        node->addChild($3);
        $$=node;
    }
    | IDS MULTO expr{
        TreeNode* node=new TreeNode(NODE_ASSIGN);
        node->opType=OP_MULTI;
        node->addChild($1);
        node->addChild($3);
        $$=node;
    }
    | IDS DIVTO expr{
        TreeNode* node=new TreeNode(NODE_ASSIGN);
        node->opType=OP_DIV;
        node->addChild($1);
        node->addChild($3);
        $$=node;
    }
    | ID MODTO expr{
        TreeNode* node=new TreeNode(NODE_ASSIGN);
        node->opType=OP_MOD;
        node->addChild($1);
        node->addChild($3);
        $$=node;
    }
    | IDS DADD {
        TreeNode *node=new TreeNode(NODE_ASSIGN);
        node->opType=OP_DADD;
        node->addChild($1);
        $$=node; 
    }
    | IDS DMIN {
        TreeNode *node=new TreeNode(NODE_ASSIGN);
        node->opType=OP_DMIN;
        node->addChild($1);
        $$=node; 
    }
    ;
args
    : IDS {$$=$1;}
    | operation {$$=$1;}
    | IDadd {$$=$1;}
    | IDptr {$$=$1;}
    | args COMMA operation {$$=$1; $$->addSibling($3);}
    | args COMMA IDS {$$=$1; $$->addSibling($3);}
    | args COMMA IDadd {$$=$1; $$->addSibling($3);}
    | args COMMA IDptr {$$=$1; $$->addSibling($3);}
    ;

def_func
    : type ID LPAREN args RPAREN statement {
        TreeNode *node=new TreeNode(NODE_FUNC);
        node->addChild($1);
        node->addChild($2);
        node->addChild($4);
        node->addChild($6);
        $$=node;
    }
    | type ID LPAREN RPAREN statement {
        TreeNode *node=new TreeNode(NODE_FUNC);
        node->addChild($1);
        node->addChild($2);
        node->addChild($5);
        $$=node;
    }
    ;

if_else
    : IF bool_statment statement %prec LOWER_THEN_ELSE {
        TreeNode *node=new TreeNode(NODE_STMT);
        node->stmtType=STMT_IF;
        node->addChild($2);
        node->addChild($3);
        $$=node;
    }
    | IF bool_statment statement ELSE statement {
        TreeNode *node=new TreeNode(NODE_STMT);
        node->stmtType=STMT_IF;
        node->addChild($2);
        node->addChild($3);
        node->addChild($5);
        $$=node;
    }
    ;
while
    : WHILE bool_statment statement {
        TreeNode *node=new TreeNode(NODE_STMT);
        node->stmtType=STMT_WHILE;
        node->addChild($2);
        node->addChild($3);
        $$=node;
    }
    ;
for
    : FORE for_expr statement{
        TreeNode *node=new TreeNode(NODE_STMT);
        node->stmtType=STMT_FOR;
        node->addChild($2);
        node->addChild($3);
        $$=node;
    }
    ;
FORE
    : FOR
    {
        $$=$1;
    }
for_expr
    : LPAREN instruction bool_expr SEMICOLON operation RPAREN{
        TreeNode *node=new TreeNode(NODE_FEXPR);
        node->addChild($2);
        node->addChild($3);
        node->addChild($5);
        $$=node;
    }
bool_statment
    : LPAREN bool_expr RPAREN {$$=$2;}
    ;
instruction
    : type args SEMICOLON {
        TreeNode *node=new TreeNode(NODE_STMT);
        node->stmtType=STMT_DECL;
        node->addChild($1);
        node->addChild($2);
        $$=node;
        int preflag = 0;
        vector<variable> l;
        if(!scopes.empty())
        {
            l = scopes[scopes.size()-1].varies;
        }
        for(int i = 1;i < node->childNum();i++)
        {
            TreeNode* cld = node->getChild(i);
            for(int j = l.size();j < curscope.size();j++)
            {
                if(curscope[j].name == (cld->nodeType==NODE_ASSIGN?cld->getChild(0)->varName:cld->varName))
                {
                    printf("ParseError(Same Variable)");
                    scope(curscope, sindex).output();
                    preflag = 1;
                    break;
                }
            }
            if(!preflag)
            {
                curscope.push_back(variable($1->varType, cld->nodeType==NODE_ASSIGN?cld->getChild(0)->varName:cld->varName, sindex));
            }
            preflag = 0;
        }
    }
    | args SEMICOLON {
        TreeNode *node=new TreeNode(NODE_STMT);
        node->stmtType=STMT_ASSIGN;
        node->addChild($1);
        $$=node;  
    }
    | CONST type args SEMICOLON {
        TreeNode *node=new TreeNode(NODE_STMT);
        node->stmtType=STMT_DECL;
        node->addChild($2);
        node->addChild($3);
        $$=node;
        int preflag = 0;
        vector<variable> l;
        if(!scopes.empty())
        {
            l = scopes[scopes.size()-1].varies;
        }
        for(int i = 1;i < node->childNum();i++)
        {
            TreeNode* cld = node->getChild(i);
            for(int j = l.size();j < curscope.size();j++)
            {
                if(curscope[j].name == (cld->nodeType==NODE_ASSIGN?cld->getChild(0)->varName:cld->varName))
                {
                    printf("ParseError(Same Variable)");
                    scope(curscope, sindex).output();
                    preflag = 1;
                    break;
                }
            }
            if(!preflag)
            {
                curscope.push_back(variable($2->varType, cld->nodeType==NODE_ASSIGN?cld->getChild(0)->varName:cld->varName, sindex));
            }
            preflag = 0;
        }
    }
    ;
printf
    : PRINTF LPAREN STRING COMMA args RPAREN {
        TreeNode *node=new TreeNode(NODE_STMT);
        node->stmtType=STMT_PRINTF;
        node->addChild($3);
        node->addChild($5);
        $$=node;
    }
    | PRINTF LPAREN STRING RPAREN{
        TreeNode *node=new TreeNode(NODE_STMT);
        node->stmtType=STMT_PRINTF;
        node->addChild($3);
        $$=node;
    }
    | PRINTF LPAREN ID RPAREN{     
        TreeNode *node=new TreeNode(NODE_STMT);
        node->stmtType=STMT_PRINTF;
        node->addChild($3);
        $$=node;
    }
    ;
scanf
    : SCANF LPAREN STRING COMMA args RPAREN {
        TreeNode *node=new TreeNode(NODE_STMT);
        node->stmtType=STMT_SCANF;
        node->addChild($3);
        node->addChild($5);
        $$=node;
    }
    ;
bool_expr
    : TRUE {$$=$1;}
    | FALSE {$$=$1;}
    | expr EQ expr {
        TreeNode *node=new TreeNode(NODE_OP);
        node->opType=OP_EQ;
        node->addChild($1);
        node->addChild($3);
        $$=node;
    }
    | expr NE expr {
        TreeNode *node=new TreeNode(NODE_OP);
        node->opType=OP_NE;
        node->addChild($1);
        node->addChild($3);
        $$=node;
    }
    | expr BT expr {
        TreeNode *node=new TreeNode(NODE_OP);
        node->opType=OP_BT;
        node->addChild($1);
        node->addChild($3);
        $$=node;
    }
    | expr BE expr {
        TreeNode *node=new TreeNode(NODE_OP);
        node->opType=OP_BE;
        node->addChild($1);
        node->addChild($3);
        $$=node;
    }
    | expr LT expr {
        TreeNode *node=new TreeNode(NODE_OP);
        node->opType=OP_LT;
        node->addChild($1);
        node->addChild($3);
        $$=node;
    }
    | expr LE expr {
        TreeNode *node=new TreeNode(NODE_OP);
        node->opType=OP_LE;
        node->addChild($1);
        node->addChild($3);
        $$=node;
    }
    | bool_expr AND bool_expr {
        TreeNode *node=new TreeNode(NODE_OP);
        node->opType=OP_AND;
        node->addChild($1);
        node->addChild($3);
        $$=node;
    }
    | bool_expr OR bool_expr {
        TreeNode *node=new TreeNode(NODE_OP);
        node->opType=OP_OR;
        node->addChild($1);
        node->addChild($3);
        $$=node;
    }
    | NOT bool_expr {
        TreeNode *node=new TreeNode(NODE_OP);
        node->opType=OP_NOT;
        node->addChild($2);
        $$=node;        
    }
    ;
expr
    : IDS {$$=$1;}
    | INTEGER {$$=$1;}
    | CHARACTER {$$=$1;}
    | STRING {$$=$1;}
    | expr ADD expr {
        TreeNode *node=new TreeNode(NODE_OP);
        node->opType=OP_ADD;
        node->addChild($1);
        node->addChild($3);
        $$=node;   
    }
    | expr MINUS expr {
        TreeNode *node=new TreeNode(NODE_OP);
        node->opType=OP_MINUS;
        node->addChild($1);
        node->addChild($3);
        $$=node;   
    }
    | expr MULTI expr {
        TreeNode *node=new TreeNode(NODE_OP);
        node->opType=OP_MULTI;
        node->addChild($1);
        node->addChild($3);
        $$=node;   
    }
    | expr DIV expr {
        TreeNode *node=new TreeNode(NODE_OP);
        node->opType=OP_DIV;
        node->addChild($1);
        node->addChild($3);
        $$=node;   
    }
    | expr MOD expr {
        TreeNode *node=new TreeNode(NODE_OP);
        node->opType=OP_MOD;
        node->addChild($1);
        node->addChild($3);
        $$=node;   
    }
    | MINUS expr %prec NEG {
        TreeNode *node=new TreeNode(NODE_OP);
        node->opType=OP_NEG;
        node->addChild($2);
        $$=node; 
    }
    ;
type
    : INT {
        TreeNode *node=new TreeNode(NODE_TYPE);
        node->varType=VAR_INTEGER;
        $$=node; 
    }
    | VOID {
        TreeNode *node=new TreeNode(NODE_TYPE);
        node->varType=VAR_VOID;
        $$=node;         
    }
    | CHAR {
        TreeNode *node=new TreeNode(NODE_TYPE);
        node->varType=VAR_CHAR;
        $$=node;
    }
    ;
struct_def
    : STRUCT ID LBRACE struct_ins RBRACE args SEMICOLON
    {
        TreeNode* node = new TreeNode(NODE_STRDEF);
        node->addChild($2);
        node->addChild($4);
        int cnum = node->childNum();
        str_name[name_num]=$2->varName;
        node->addChild($6);                    
        $$=node;
        scopes.pop_back();
        struct_def str($2->varName, curscope);
        curscope.clear();
        curscope.assign(strscope.begin(), strscope.end());
        str.struct_index = struct_num++;
        strdef.push_back(str);
        for(int i = cnum;i < node->childNum();i++)
        {
            curscope.push_back(variable((name_num+4), node->getChild(i)->varName, cur_sindex, str_name[name_num]));
        }
        name_num++;
        strscope.assign(curscope.begin(), curscope.end());
        sindex=cur_sindex;
    }
    | STRUCT ID LBRACE struct_ins RBRACE SEMICOLON
    {
        TreeNode* node = new TreeNode(NODE_STRDEF);
        node->addChild($2);
        node->addChild($4);
        scopes.pop_back();
        struct_def str($2->varName, curscope);
        str.struct_index = struct_num++;
        strdef.push_back(str);
        curscope.clear();
        $$=node;
    }
    ;
struct_ins
    : instruction {$$=$1;}
    | struct_ins instruction {$$=$1;$$->addSibling($2);}
    ;
ID-array
    : ID LBRACK expr RBRACK {
        $$=$1;
        $$->dim.push_back($3);
    }
    | ID-array LBRACK expr RBRACK {
        $$=$1;
        $$->dim.push_back($3);
    }
    ;
ID-member
    : ID dot ID {
        $$=$1;
        $$->addChild($3);
    }
    | ID-array dot ID {
        $$=$1;
        $$->addChild($3);
    }
    | ID dot ID-array {
        $$=$1;
        $$->addChild($3);
    }
    | ID-array dot ID-array {
        $$=$1;
        $$->addChild($3);
    }
    | ID-member dot ID {
        $$=$1;
        $$->addChild($3);
    }
    | ID-member dot ID {
        $$=$1;
        $$->addChild($3);
    }
    | ID-member dot ID-array {
        $$=$1;
        $$->addChild($3);
    }
    ;
IDS 
    : ID {$$=$1;}
    | ID-array {$$=$1;}
    | ID-member {$$=$1;}
    
%%