require 'spec_helper'

describe Robot do

  let(:robot) {Robot.new({space_width: 8, space_height: 8})}
  let(:frozen_robot) { Robot.new({space_width: 8, space_height: 8}).freeze }
  let(:placed_robot) do
    r = Robot.new({space_width: 8, space_height: 8})
    r.send(:place, 2, 3, "WEST")
    r
  end

  describe "::new" do
    it{ should be_instance_of(Robot) }
    it{ Robot.constants.should == [:COURSE] }
    it{ Robot::COURSE.should_not be_nil }
    it{ Robot::COURSE.should eq ['NORTH', 'EAST', 'SOUTH', 'WEST'] }
    it{ Robot::COURSE.should be_frozen }
  end

  describe "#initialize" do

    it{ subject.instance_variable_get(:@position).should_not be_nil }
    it{ subject.instance_variable_get(:@position).should be_empty }
    it{ subject.instance_variable_get(:@course_index).should == 0 }
    it{ subject.instance_variable_get(:@init).should_not be_nil }
    it{ subject.instance_variable_get(:@init).should be_false }

    context "with default options" do
      it{ subject.instance_variable_get(:@width).should == 5 }
      it{ subject.instance_variable_get(:@height).should == 6 }
    end

    context "with some options" do
      it{ robot.instance_variable_get(:@width).should == 8 }
      it{ robot.instance_variable_get(:@height).should == 8 }
    end
  end

  describe "#exec" do
    context "when input string" do

      context "is nil" do
        it "application not raise error" do
          expect { robot.exec(nil) }.not_to raise_error
        end
        it "robot does nothing" do
          expect { frozen_robot.exec(nil) }.not_to raise_error
        end
      end

      context "is empty" do
        it "application not raise error" do
          expect { robot.exec("") }.not_to raise_error
        end
        it "robot does nothing" do
          expect { frozen_robot.exec("") }.not_to raise_error
        end
      end

      context "is incorrect" do
        it "application not raise error" do
          expect { robot.exec("wrong command") }.not_to raise_error
        end
        it "robot does nothing" do
          expect { frozen_robot.exec("wrong command") }.not_to raise_error
        end
      end

      context "equal correct command" do

        context "and robot isn't placed" do
          context "and command isn't 'PLACE'" do
            it "application not raise error" do
              expect { robot.exec("LEFT") }.not_to raise_error
            end
            it "robot does nothing" do
              expect { frozen_robot.exec("wrong command") }.not_to raise_error
            end
          end

          context "and command is 'PLACE'" do
            it "application not raise error" do
              expect { robot.exec("PLACE 0,0,NORTH") }.not_to raise_error
            end
            it "place robot on table (some 2D space)" do
              # robot.exec("PLACE 0,0,NORTH").should == true ----> ok if aren't any exceptions
              frozen_robot.exec("PLACE 0,0,NORTH").should == false # ok if app raise any exception, e.g. "expected Exception but nothing was raised"
            end
          end
        end

        context "and robot is placed" do
          before do
            robot.exec("PLACE 0,0,NORTH")
            @placed_frozen_robot = Robot.new
            @placed_frozen_robot.exec("PLACE 0,0,NORTH")
            @placed_frozen_robot.freeze
          end

          it "application not raise error" do
            expect { robot.exec("LEFT") }.not_to raise_error
          end
          it "robot execute command" do
            @placed_frozen_robot.exec("PLACE 0,0,NORTH").should == false
          end

        end
      end
    end

  end

  describe "#placed?" do
    it "return @init" do
      robot.send(:placed?).should == robot.instance_variable_get(:@init)
    end
  end

  describe "#incorrect_coordinates?" do
    it {placed_robot.send(:incorrect_coordinates?, 1, 0).should be_false}
    it {placed_robot.send(:incorrect_coordinates?, -2, 1).should be_true}
    it {placed_robot.send(:incorrect_coordinates?, 6, 500).should be_true}
  end

  describe "#correct_course?" do
    it {placed_robot.send(:correct_course?, "WEST").should be_true}
    it {placed_robot.send(:correct_course?, "EAST").should be_true}
    it {placed_robot.send(:correct_course?, "NORTH").should be_true}
    it {placed_robot.send(:correct_course?, "SOUTH").should be_true}
    it {placed_robot.send(:correct_course?, "QUIT").should be_false}
  end

  describe "#report" do
    it {placed_robot.send(:report).should == "Current position [2, 3]. Course WEST"}
  end

  describe "#left" do
    it "rotate 1 position left" do
      Robot::COURSE[placed_robot.instance_variable_get(:@course_index)].should == "WEST"
      placed_robot.send(:left)
      Robot::COURSE[placed_robot.instance_variable_get(:@course_index)].should == "SOUTH"
    end
    it "rotate 6 position left" do
      Robot::COURSE[placed_robot.instance_variable_get(:@course_index)].should == "WEST"
      6.times { placed_robot.send(:left) }
      Robot::COURSE[placed_robot.instance_variable_get(:@course_index)].should == "EAST"
    end
  end

  describe "#right" do
    it "rotate 1 position right" do
      Robot::COURSE[placed_robot.instance_variable_get(:@course_index)].should == "WEST"
      placed_robot.send(:right)
      Robot::COURSE[placed_robot.instance_variable_get(:@course_index)].should == "NORTH"
    end
    it "rotate 6 position right" do
      Robot::COURSE[placed_robot.instance_variable_get(:@course_index)].should == "WEST"
      6.times { placed_robot.send(:right) }
      Robot::COURSE[placed_robot.instance_variable_get(:@course_index)].should == "EAST"
    end
  end

  describe "#place" do
    context "when wrong" do
      it "x coordinate" do
        expect { robot.send(:place, -1, 0, "WEST")}.not_to raise_error
        frozen_robot.send(:place, -1, 0, "WEST").should == false
      end
      it "y coordinate" do
        expect { robot.send(:place, 0, -2, "WEST")}.not_to raise_error
        frozen_robot.send(:place, 0, -2, "WEST").should == false
      end
      it "course" do
        expect { robot.send(:place, 0, 0, "HOME")}.not_to raise_error
        frozen_robot.send(:place, 0, 0, "HOME").should == false
      end
    end

    context "when correct params" do
      it "establish robot in a new place" do
        robot.send(:place, 1, 3, "WEST")
        new_position = robot.instance_variable_get(:@position)
        new_position[:x].should == 1
        new_position[:y].should == 3
        Robot::COURSE[robot.instance_variable_get(:@course_index)].should == "WEST"
        robot.instance_variable_get(:@init).should be_true
      end
    end
  end
end