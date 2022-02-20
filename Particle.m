classdef Particle
    properties
        x
        l
        u
        v
        objective
        infeasibility
        fcn
        pBest
        pBest_objective
        pBest_infeasablity
    end

    methods
        function obj = Particle(lower,upper,problem)
            if nargin>0
                obj.x = unifrnd(lower,upper);
                obj.l = lower;
                obj.u = upper;
                obj.v = zeros(1,max(length(lower),length(upper)));
                obj.fcn = problem;
                [obj.objective, obj.infeasibility] = obj.fcn(obj.x);
                obj.pBest = obj.x;
                obj.pBest_objective = obj.objective;
                obj.pBest_infeasablity = obj.infeasibility;
            end
        end
        function [obj]= update(obj,w,c,pm,gBest)
            obj = obj.updateV(w,c,gBest).updateX();
            [obj.objective, obj.infeasibility] = obj.fcn(obj.x);
            obj = obj.applyMutatation(pm).updatePbest();
        end
        function obj = updateV(obj,w,c,gBest)
            obj.v = w.*obj.v + c(1).*rand.*(obj.pBest-obj.x) + c(2).*rand.*(gBest.x-obj.x);
        end
        function obj = updateX(obj)
            obj.x = max(obj.l,min(obj.x + obj.v,obj.u));
        end
        function obj = applyMutatation(obj,pm)
            if rand<pm
                other=obj.Mutate(pm);
                [other.objective,other.infeasibility]=obj.fcn(other.x);
                if rand<0.5 || other.dominates(obj)
                    obj=other;
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
        function tf = dominates(obj,obj1)
            tf = ((obj.infeasibility <= obj1.infeasibility) && (obj.objective < obj1.objective));
        end
        function tf = ne(objs,other)
            tf = any(vertcat(objs.x) ~= other.x,2);
        end
        function tf = eq(objs,other)
            tf = any(vertcat(objs.x) == other.x,2);
        end
        function obj = updatePbest(obj)
            if (obj.infeasibility <= obj.pBest_infeasablity) && (obj.objective < obj.pBest_objective)
              obj.pBest = obj.x;
              obj.pBest_objective = obj.objective;
              obj.pBest_infeasablity = obj.infeasibility;
            end
        end
        function [M,I] = best(objs)
            infeasibilities = horzcat(objs.infeasibility);
            [~,I] = min(infeasibilities);
            M = objs(I);
            for i = find(infeasibilities==M.infeasibility)
                if objs(i).dominates(M)
                    M = objs(i);
                    I = i;
                end
            end
        end
    end
end
