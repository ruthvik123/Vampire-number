defmodule Vampire.Application.Server do
  use GenServer

  #####
  # External API

  @spec start_link(any) :: :ignore | {:error, any} | {:ok, pid}
  def start_link(dict) do
    GenServer.start_link __MODULE__, dict , name: __MODULE__
  end

  def add_key(k,v) do
    GenServer.call __MODULE__, {:add_key,k,v}
  end

  def showDict() do
    GenServer.call __MODULE__,:show
  end

  #####
  # GenServer implementation

  def handle_call({:add_key,k,v}, _from, dict) do  # k-> no. v-> [fangs]
    # x = current_number+ 10
    # { :reply, x, x }
    if Map.has_key?(dict, k) do
      temp = Enum.at(v, 0)
      {:ok,valList} = Map.fetch(dict, k)

      if not Enum.member?(valList, temp) do
        existing_val = Map.fetch!(dict, k)
        new_val = existing_val ++ v
        new = Map.replace!(dict, k , new_val)
        { :reply, new, new }
      else
        new = dict
        { :reply, new, new }
      end
    else
      new = Map.put(dict, k, v)
      { :reply, new, new }
    end

  end
  ###

  def handle_call(:show, _from, dict) do
    {:reply, dict, dict}

  end
  ##

  ## LOGIC

  def hello(i,j) do

    l = i..j
    Enum.each(l, fn(s)->
    x = Integer.to_string(s)
    len = String.length(x)
    bool = rem(len,2)
    if  bool == 0 do
      spawn(Vampire.Application.Server, :mainLogic,[x,len])
    end
  end)
  end  #  Working


  # Main Logic
  def mainLogic(strNo, len ) do
    hl = len/2  # half length
    min = :math.pow(10, hl-1) |> round
    max = :math.pow(10, hl)-1 |> round
    #IO.puts(is_integer(max))
    checkRange = min..max
    test_number = String.to_integer(strNo)


    Enum.each(checkRange,fn(n1) ->

        is_factor1 = rem(test_number,n1)

        if  is_factor1 == 0 do

        n2 = test_number/n1 |> round

        # IO.puts("#{n1} #{n2}")

        rem1 = rem(n1,10) # Check trailing zeros
        rem2 = rem(n2,10) #
        if ((rem1 == 0 && rem2 != 0) || (rem1 != 0 && rem2 == 0) || (rem1 != 0 && rem2 != 0) ) do
          numlist = Integer.digits(n1) ++ Integer.digits(n2)
          targetList = Integer.digits(test_number)
          spawn(Vampire.Application.Server, :finalCheck,[numlist,targetList,n1,n2])
          #IO.puts("#{n1} #{n2}")
        end
      end
  end
    )
  end


    # Final Logic

  def finalCheck(num,target,n1,n2) do
    l1 = Enum.sort(num)
    l2 = Enum.sort(target)
    if l1 == l2 do
      num = n1*n2
      # IO.puts("#{num}   #{n1}  #{n2}")
      add_key(num,[n1,n2])
      num

    end
  end

  ## Printing function

 def printNum() do
 data =  showDict()

 Enum.each(data, fn{k,v} ->
  IO.inspect("#{k}"<>" "<> Enum.reduce(v, fn x, acc -> "#{x}"<>" "<>"#{acc}" end))
  end
 )
end
##
# def measure(function) do
#   function
#   |> :timer.tc
#   |> elem(0)
#   |> Kernel./(1_000_000)


# end

## Module end
end
