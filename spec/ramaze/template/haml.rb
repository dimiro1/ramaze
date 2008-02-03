#          Copyright (c) 2006 Michael Fellinger m.fellinger@gmail.com
# All files in this distribution are subject to the terms of the Ruby license.

require 'spec/helper'

spec_require 'ramaze/template/haml'

class TCTemplateHamlController < Ramaze::Controller
  map :/
  template_root __DIR__/:haml
  engine :Haml

  helper :link

  def index
  end

  def with_vars
    @title = "Teen Wolf"
  end
end

class TCRamazeLocals < Ramaze::Controller
  map '/test'
  template_root __DIR__/:haml

  def render_with_locals
    render_template 'locals.haml', :abc => 'def'
  end
end

class TCTemplateHamlLocalsController < Ramaze::Controller
  map '/locals'
  engine :Haml
  trait :haml_options => { :locals => { :localvar => 'abcdefg' } }

  def test
    %{= localvar}
  end
end

describe "Haml templates" do
  behaves_like 'http'
  ramaze(:compile => true)

  it "should render" do
    get('/').body.strip.should ==
%{<div id='contact'>
  <h1>Eugene Mumbai</h1>
  <ul class='info'>
    <li class='login'>eugene</li>
    <li class='email'>eugene@example.com</li>
  </ul>
</div>}
  end

  it "should have access to variables defined in controller" do
    get('/with_vars').body.strip.should ==
%{<div id='content'>
  <div class='title'>
    <h1>Teen Wolf</h1>
    <a href="/Home">Home</a>
  </div>
</div>}
  end

  it 'should support locals via render_template' do
    get('/test/render_with_locals').body.strip.should == 'def'
  end

  it "should have access to locals defined" do
    get('/locals/test').body.strip.should == 'abcdefg'
  end
end
