#include<string>
#include<vector>
using namespace std;
class variable
{
public:
    int type;
    string name;
    int int_val;
    string str_val;
    variable()
    {
        this->type = 0;
        this->name = ""                                                                                                                                                             ;
    }
    variable(int type, string name)
    {
        this->type = type;
        this->name = name;
    }
};
class tmpvariable
{
public:
    variable v;
    int l;
    tmpvariable(variable v, int l)
    {
        this->v = variable(v.type, v.name);
        this->l = l;
    }
};
class layer
{
public:
    vector<variable> varies;
    int lindex;
    void output()
    {
        for(int i = 0;i < varies.size();i++)
        {
            printf("%s  %d\n", varies[i].name.c_str(), lindex);
        }
    }
    layer(vector<variable> varies, int lindex)
    {
        this->varies = varies;
        this->lindex = lindex;
    }
};
