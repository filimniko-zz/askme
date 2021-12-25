class AddInterviewerIdToQuestions < ActiveRecord::Migration[6.1]
  def change
    add_column :questions, :interviewer_id, :integer
  end
end
