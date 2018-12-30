classdef Particle
    properties
        x
        l
        u
        v
        cost
        infeasablity
        pBest
        pBest_cost
        pBest_infeasablity
    end

    methods
        function obj = Particle(lower,upper,problem)
            if nargin>0
                obj.x = unifrnd(lower,upper);
                obj.l = lower;
                obj.u = upper;
                obj.v = zeros(1,max(length(lower),length(upper)));
                [obj.cost, obj.infeasablity] = problem(obj.x);
                obj.pBest = obj.x;
                obj.pBest_cost = obj.cost;
                obj.pBest_infeasablity = obj.infeasablity;
            end
        end
        function [obj]= update(obj,w,c,pm,gBest,problem)
            obj = obj.updateV(w,c,gBest);
            obj = obj.updateX();
            [obj.cost, obj.infeasablity] = problem(obj.x);
            obj = obj.applyMutatation(pm,problem);
            obj = obj.updatePbest();
        end
        function obj = updateV(obj,w,c,gBest)
            obj.v = w.*obj.v + c(1).*rand.*(obj.pBest-obj.x) + c(2).*rand.*(gBest.x-obj.x);
        end
        function obj = updateX(obj)
            obj.x = max(min(obj.x + obj.v,obj.u),obj.l);
        end
        function obj = applyMutatation(obj,pm,problem)
            if rand<pm
                X=obj.Mutate(pm);
                [X.cost,X.infeasablity]=problem(X.x);
                if X.dominates(obj)
                    obj=X;
                elseif rand<0.5
                        obj=X;
                end
            end
        end
        function obj=Mutate(obj,pm)
            nVar=numel(obj.x);
            j=randi([1 nVar]);
            dx=pm*(obj.u(j)-obj.l(j));
            lb=max(obj.x(j)-dx,obj.l(j));
            ub=min(obj.x(j)+dx,obj.u(j));
            obj.x(j)=unifrnd(lb,ub);
        end
        function d = dominates(obj,obj1)
            d = ((obj.infeasablity <= obj1.infeasablity) && (obj.cost < obj1.cost));
        end
        function obj = updatePbest(obj)
            if (obj.infeasablity <= obj.pBest_infeasablity) && (obj.cost < obj.pBest_cost)
              obj.pBest = obj.x;
              obj.pBest_cost = obj.cost;
              obj.pBest_infeasablity = obj.infeasablity;
            end
        end
    end
end
